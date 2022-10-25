use crate::{database::articles::Articles, models::article::Article};
use rocket::serde::json::Json;
use rocket_db_pools::sqlx::Row;
use rocket_db_pools::{sqlx::query, Connection};
use uuid::Uuid;

#[get("/articles")]
pub fn get_all_articles() -> Json<Vec<Article>> {
    return Json(vec![Article::new("".to_string(), "".to_string())]);
}

#[get("/articles/<id>")]
pub async fn get_one_article(mut db: Connection<Articles>, id: &str) -> Option<Json<Article>> {
    let response = query("SELECT id, title, text FROM articles WHERE id=?")
        .bind(id)
        .fetch_one(&mut *db)
        .await
        .and_then(|r| Ok(Json(Article::new(r.try_get(1)?, r.try_get(2)?))))
        .ok();
    response
}

#[post("/articles", format = "json", data = "<article>")]
pub async fn post_one_article(mut db: Connection<Articles>, article: Json<Article>) -> String {
    let response = query("INSERT INTO articles (id, title, content) VALUES (?, ?, ?)")
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
