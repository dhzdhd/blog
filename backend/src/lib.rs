#[macro_use]
extern crate rocket;
use rocket::{
    get, launch, routes,
    serde::json::{serde_json::json, Value},
};

mod database;
mod models;
mod routes;

#[catch(404)]
fn not_found() -> Value {
    json!({
        "status": "error",
        "reason": "Resource was not found."
    })
}

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

#[launch]
pub fn rocket() -> _ {
    rocket::build()
        .mount(
            "/api/v1",
            routes![index, routes::articles::get_all_articles,],
        )
        .register("/", catchers![not_found])
}
