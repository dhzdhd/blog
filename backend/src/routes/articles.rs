use crate::models::article::ArticleResponse;
use rocket::serde::json::Json;

#[get("/articles")]
pub fn get_all_articles<'a>() -> Json<Vec<ArticleResponse<'a>>> {
    return Json(vec![ArticleResponse::new("", "", vec![""])]);
}

#[get("/articles/<id>")]
pub fn get_one_article<'a>(id: &'a str) -> Json<ArticleResponse<'a>> {
    return Json(ArticleResponse::new("", "", vec![""]));
}
