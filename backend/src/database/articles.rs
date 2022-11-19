use rocket_db_pools::sqlx::{self, migrate};
use rocket_db_pools::Database;

#[derive(Database)]
#[database("blog")]
pub struct Articles(sqlx::PgPool);
