use blog;
use rocket;

#[rocket::main]
async fn main() {
    let _ = blog::rocket().launch().await;
}
