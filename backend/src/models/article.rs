use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
pub struct Article {
    title: String,
    content: String,
}

impl Article {
    pub fn new(title: String, content: String) -> Self {
        Self { title, content }
    }
}
