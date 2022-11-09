use crate::models::article::ArticleVec;
use crate::{database::articles::Articles, models::article::Article};
use rocket::serde::json::Json;
use rocket_db_pools::sqlx::Row;
use rocket_db_pools::{sqlx::query, Connection};
use uuid::Uuid;

#[get("/articles")]
pub async fn get_all_articles(mut db: Connection<Articles>) -> Option<Json<ArticleVec>> {
    let response = query("SELECT id, title, content FROM articles")
        .fetch_all(&mut *db)
        .await
        .and_then(|r| {
            Ok(Json(ArticleVec::new(
                r.into_iter()
                    .map(|r| {
                        let s: &str = r.try_get(1).unwrap();
                        println!("{s}");
                        Article::new(r.try_get(1).unwrap(), r.try_get(2).unwrap())
                    })
                    .collect::<Vec<Article>>(),
            )))
            // Ok(Json(Article::new(r.try_get(1)?, r.try_get(2)?)))
        })
        .ok();

    response
}

#[get("/articles/<id>")]
pub async fn get_one_article(mut db: Connection<Articles>, id: &str) -> Option<Json<Article>> {
    println!("{id}");
    let response = query("SELECT id, title, content FROM articles WHERE id=$1")
        .bind(id)
        .fetch_one(&mut *db)
        .await
        .and_then(|r| {
            println!("{:?}", r.try_get(1)?);
            Ok(Json(Article::new(r.try_get(1)?, r.try_get(2)?)))
        })
        .ok();
    response
}

#[post("/articles", format = "json", data = "<article>")]
pub async fn post_one_article(mut db: Connection<Articles>, article: Json<Article>) -> String {
    let response = query(r#"INSERT INTO articles(id, title, content) VALUES ($1, $2, $3)"#)
        .bind(Uuid::new_v4().to_string())
        .bind(article.0.title)
        .bind(article.0.content)
        .execute(&mut *db)
        .await;

    match response {
        Ok(_) => "Successful".to_string(),
        Err(err) => err.to_string(),
    }
}
