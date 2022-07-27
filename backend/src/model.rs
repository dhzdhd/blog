use rocket::serde::Deserialize;

#[derive(Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct Response<'a> {
    message: &'a str,
    status: i32,
}
