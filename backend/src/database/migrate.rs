use rocket::fairing;
use rocket::Build;
use rocket::Rocket;
use rocket_db_pools::sqlx::migrate;
use rocket_db_pools::Database;

use super::articles::Articles;

pub async fn run_migrations(rocket: Rocket<Build>) -> fairing::Result {
    match Articles::fetch(&rocket) {
        Some(db) => match migrate!("db/migrations").run(&**db).await {
            Ok(_) => Ok(rocket),
            Err(e) => {
                error!("Failed to initialize SQLx Postgres database: {}", e);
                Err(rocket)
            }
        },
        None => {
            error!("Failed to initialize SQLx Postgres database");
            Err(rocket)
        }
    }
}
