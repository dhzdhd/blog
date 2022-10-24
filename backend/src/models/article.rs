use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct Article<'a> {
    title: &'a str,
    content: &'a str,
    author: Vec<&'a str>,
}

impl<'a> Article<'a> {
    pub fn new(title: &'a str, content: &'a str, author: Vec<&'a str>) -> Self {
        Self {
            title,
            content,
            author,
        }
    }
}
