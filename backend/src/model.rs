use rocket::serde::{Deserialize, Serialize};

#[derive(Serialize)]
#[serde(crate = "rocket::serde")]
pub struct Response<'a> {
    message: &'a str,
    status: i32,
}

impl<'a> Response<'a> {
    pub fn new(message: &'a str, status: i32) -> Self {
        Self { message, status }
    }
}

#[derive(Deserialize)]
#[serde(crate = "rocket::serde")]
pub struct BlogPostRequest<'a> {
    pub title: &'a str,
    pub content: &'a str,
    pub authors: Vec<&'a str>,
    pub date: &'a str,
}

impl<'a> BlogPostRequest<'a> {
    pub fn new(title: &'a str, content: &'a str, authors: Vec<&'a str>, date: &'a str) -> Self {
        Self {
            title,
            content,
            authors,
            date,
        }
    }
}
