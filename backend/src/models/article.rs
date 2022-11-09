use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct ArticleVec {
    data: Vec<Article>,
}

impl ArticleVec {
    pub fn new(data: Vec<Article>) -> Self {
        Self { data }
    }
}

#[derive(Serialize, Deserialize)]
pub struct Article {
    pub title: String,
    pub content: String,
}

impl Article {
    pub fn new(title: String, content: String) -> Self {
        Self { title, content }
    }
}
