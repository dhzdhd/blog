use blog;
use dotenv::dotenv;
use rocket;

#[rocket::main]
async fn main() -> Result<(), rocket::Error> {
    dotenv().ok();

    blog::rocket().launch().await?;
    Ok(())
}
