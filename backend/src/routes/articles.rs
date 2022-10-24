use crate::{database::articles::Articles, models::article::Article};
use rocket::serde::json::Json;
use rocket_db_pools::{sqlx::query, Connection};

#[get("/articles")]
pub fn get_all_articles<'a>() -> Json<Vec<Article<'a>>> {
    return Json(vec![Article::new("", "", vec![""])]);
}

#[get("/articles/<id>")]
pub fn get_one_article<'a>(mut db: Connection<Articles>, id: &str) -> Json<Article<'a>> {
    query("SELECT ").bind(id);

    return Json(Article::new("", "", vec![""]));
}

#[post("/articles", format = "json", data = "<article>")]
pub fn post_one_article(mut db: Connection<Articles>, article: Json<Article>) {}
