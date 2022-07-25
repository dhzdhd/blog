use std::collections::HashMap;

#[macro_use]
extern crate rocket;

struct Response<'a> {
    msg: &'a str,
}

#[get("/blog/<id>")]
async fn blog(id: i32) -> &'static str {
    "e"
}

#[get("/")]
async fn index() -> &'static str {
    "Hello, world!"
}

#[get("/error")]
async fn error() -> String {
    "hello".to_owned()
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/api/", routes![index, error])
}
