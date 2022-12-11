#[macro_use]
extern crate rocket;
use rocket::fairing::{Fairing, Info, Kind};
use rocket::http::Header;
use rocket::{
    fairing::AdHoc,
    launch, routes,
    serde::json::{serde_json::json, Value},
};
use rocket::{Request, Response};
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

pub struct CORS;

#[rocket::async_trait]
impl Fairing for CORS {
    fn info(&self) -> Info {
        Info {
            name: "Add CORS headers to responses",
            kind: Kind::Response,
        }
    }

    async fn on_response<'r>(&self, _request: &'r Request<'_>, response: &mut Response<'r>) {
        response.set_header(Header::new("Access-Control-Allow-Origin", "*"));
        response.set_header(Header::new(
            "Access-Control-Allow-Methods",
            "POST, GET, PATCH, OPTIONS",
        ));
        response.set_header(Header::new("Access-Control-Allow-Headers", "*"));
        response.set_header(Header::new("Access-Control-Allow-Credentials", "true"));
    }
}

#[launch]
pub fn rocket() -> _ {
    rocket::custom(rocket::Config::figment().merge((
        "databases.blog",
        rocket_db_pools::Config {
            url: "postgres://postgres:postgres@localhost:5432/blog".into(),
            min_connections: None,
            max_connections: 1024,
            connect_timeout: 30,
            idle_timeout: None,
        },
    )))
    // rocket::build()
    .attach(database::articles::Articles::init())
    .attach(database::users::Users::init())
    .attach(AdHoc::try_on_ignite(
        "SQLx Migrations",
        database::migrate::run_migrations,
    ))
    .mount(
        "/api/v1",
        routes![
            routes::index::index,
            routes::articles::get_all_articles,
            routes::articles::get_one_article,
            routes::articles::post_one_article,
            routes::articles::post_one_article_with_file,
            routes::articles::delete_one_article,
            routes::articles::update_one_article,
        ],
    )
    .register("/", catchers![not_found])
    .attach(CORS)
}
