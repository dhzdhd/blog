use serde::Serialize;

#[derive(Serialize)]
pub struct ArticleResponse<'a> {
    title: &'a str,
    content: &'a str,
    author: Vec<&'a str>,
}

impl<'a> ArticleResponse<'a> {
    pub fn new(title: &'a str, content: &'a str, author: Vec<&'a str>) -> Self {
        Self {
            title,
            content,
            author,
        }
    }
}
