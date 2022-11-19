use rocket_db_pools::sqlx::{self};
use rocket_db_pools::Database;

#[derive(Database)]
#[database("blog")]
pub struct Users(sqlx::PgPool);
