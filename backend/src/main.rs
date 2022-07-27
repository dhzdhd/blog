mod database;
mod model;

use database::Blogs;
use rocket::serde::json::Json;
use rocket_db_pools::Database;

#[macro_use]
extern crate rocket;

#[get("/")]
async fn index() -> &'static str {
    "
    USAGE

        POST /blogs/<name>
            accepts title and content and stores it as a blog post

        GET /blogs/<id>
            retrieve a post with name `<name>`

        GET /blogs
            retrieves all posts

        DELETE /blogs/<name>
            deletes the post by name
    "
}

#[post("/blogs", format = "json", data = "<info>")]
async fn create_blog(info: &str) -> Json<i32> {
    Json::from(2)
}

#[get("/blogs/<id>", format = "json")]
async fn get_blog_int<'a>(id: i32) -> &'static str {
    "e"
}

#[get("/blogs/<id>", rank = 2)]
async fn get_blog_str<'a>(id: &str) -> &'static str {
    "ID parameter has to be an integer only!"
}

#[get("/blogs")]
async fn get_all_blogs<'a>() -> &'static str {
    "e"
}

#[get("/error")]
async fn error() -> String {
    "hello".to_owned()
}

#[launch]
fn rocket() -> _ {
    rocket::build().attach(Blogs::init()).mount(
        "/api/v1",
        routes![index, error, get_blog_int, get_blog_str, get_all_blogs],
    )
}
