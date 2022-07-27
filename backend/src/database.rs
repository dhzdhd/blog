use rocket_db_pools::sqlx::{self, database, Row};
use rocket_db_pools::{Connection, Database};

#[derive(Database)]
#[database("blogs")]
pub struct Blogs(sqlx::SqlitePool);
