use std::fs;

use crate::models::article::ArticleVec;
use crate::{database::articles::Articles, models::article::Article};
use chrono::Local;
use rocket::form::Form;
use rocket::fs::TempFile;
use rocket::serde::json::Json;
use rocket_db_pools::sqlx::Row;
use rocket_db_pools::{sqlx::query, Connection};
use uuid::Uuid;

#[get("/articles")]
pub async fn get_all_articles(mut db: Connection<Articles>) -> Option<Json<ArticleVec>> {
    query("SELECT * FROM articles")
        .fetch_all(&mut *db)
        .await
        .and_then(|r| {
            Ok(Json(ArticleVec::new(
                r.into_iter()
                    .map(|r| {
                        Article::new(
                            r.try_get(0).unwrap(),
                            r.try_get(1).unwrap(),
                            r.try_get(2).unwrap(),
                            r.try_get(3).unwrap(),
                        )
                    })
                    .collect::<Vec<Article>>(),
            )))
        })
        .ok()
}

#[post("/articles", format = "json", data = "<article>", rank = 1)]
pub async fn post_one_article(mut db: Connection<Articles>, article: Json<Article>) -> String {
    let response =
        query(r#"INSERT INTO articles(id, title, content, created_at) VALUES ($1, $2, $3, $4)"#)
            .bind(Uuid::new_v4().to_string())
            .bind(article.0.title)
            .bind(article.0.content)
            .bind(match article.0.created_at {
                Some(s) => s,
                None => Local::now().date_naive(),
            })
            .execute(&mut *db)
            .await;

    match response {
        Ok(_) => "Successful".to_string(),
        Err(err) => err.to_string(),
    }
}

#[derive(FromForm)]
pub struct ArticleForm<'r> {
    // ! Add date
    file: TempFile<'r>,
    pub uid: String,
    pub title: String,
}

#[post("/articles", data = "<form>", rank = 2)]
pub async fn post_one_article_with_file(
    mut db: Connection<Articles>,
    mut form: Form<ArticleForm<'_>>,
) -> String {
    let uuid = Uuid::new_v4();
    // ! Decide file path for windows and unix
    let file_path = format!("file_path/{uuid}");
    form.file.persist_to(&file_path).await.unwrap();

    let content = fs::read_to_string(&file_path).unwrap();
    fs::remove_file(&file_path).unwrap();

    let response = query(r#"INSERT INTO articles(id, title, content) VALUES ($1, $2, $3)"#)
        .bind(Uuid::new_v4().to_string())
        .bind(&form.title)
        .bind(content)
        .execute(&mut *db)
        .await;

    match response {
        Ok(_) => "Successful".to_string(),
        Err(err) => err.to_string(),
    }
}

#[get("/articles/<id>")]
pub async fn get_one_article(mut db: Connection<Articles>, id: &str) -> Option<Json<Article>> {
    query(r#"SELECT * FROM articles WHERE id = $1"#)
        .bind(id)
        .fetch_one(&mut *db)
        .await
        .and_then(|r| {
            Ok(Json(Article::new(
                r.try_get(0).unwrap(),
                r.try_get(1).unwrap(),
                r.try_get(2).unwrap(),
                r.try_get(3).unwrap(),
            )))
        })
        .ok()
}

#[delete("/articles/<id>")]
pub async fn delete_one_article(mut db: Connection<Articles>, id: &str) -> Option<String> {
    println!("id is {id}");
    query("DELETE FROM articles WHERE id = $1")
        .bind(id)
        .execute(&mut *db)
        .await
        .and_then(|r| match r.rows_affected() {
            0 => Err(sqlx::Error::RowNotFound),
            _ => Ok("Success".to_string()),
        })
        .ok()
}

#[patch("/articles", format = "json", data = "<article>")]
pub async fn update_one_article(
    mut db: Connection<Articles>,
    article: Json<Article>,
) -> Option<String> {
    // ! add support for created_at
    query("UPDATE articles SET title = $1 AND content = $2 where id = $3")
        .bind(&article.title)
        .bind(&article.content)
        .bind(&article.uid)
        .execute(&mut *db)
        .await
        .and_then(|r| match r.rows_affected() {
            0 => Ok("Error".to_string()),
            _ => Err(sqlx::Error::RowNotFound),
        })
        .ok()
}
