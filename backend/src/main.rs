mod database;
mod model;

use database::Blogs;
use model::{BlogPostRequest, Response};
use rocket::serde::json::Json;
use rocket_db_pools::sqlx::{self};
use rocket_db_pools::{Connection, Database};

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
async fn create_blog(
    info: Json<BlogPostRequest<'_>>,
    mut db: Connection<Blogs>,
) -> Json<Response<'_>> {
    sqlx::query("INSERT INTO blogs VALUES()")
        .execute(&mut *db)
        .await
        .unwrap();

    Json::from(Response::new("Success", 200))
}

#[get("/blogs/<id>", format = "json")]
async fn get_blog_int<'a>(id: i32) -> Json<Response<'a>> {
    Json::from(Response::new("hello", 200))
}

#[get("/blogs/<id>", rank = 2)]
async fn get_blog_str(id: &str) -> &'static str {
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
