use chrono::naive::NaiveDate;
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
    pub uid: String,
    pub title: String,
    pub content: String,
    pub created_at: Option<NaiveDate>,
}

impl Article {
    pub fn new(uid: String, title: String, content: String, created_at: Option<NaiveDate>) -> Self {
        Self {
            uid,
            title,
            content,
            created_at,
        }
    }
}
