#[macro_use]
extern crate rocket;
use rocket::{
    fairing::AdHoc,
    launch, routes,
    serde::json::{serde_json::json, Value},
};
use rocket_db_pools::Database;

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

#[launch]
pub fn rocket() -> _ {
    rocket::build()
        .attach(database::articles::Articles::init())
        .attach(AdHoc::try_on_ignite(
            "SQLx Migrations",
            database::articles::run_migrations,
        ))
        .mount(
            "/api/v1",
            routes![
                routes::index::index,
                routes::articles::get_all_articles,
                routes::articles::get_one_article,
                routes::articles::post_one_article
            ],
        )
        .register("/", catchers![not_found])
}
