use serde::{Deserialize, Serialize};

pub struct AdminUser;

#[derive(Serialize, Deserialize)]
pub struct User {
    pub name: String,
    pub avatar: Option<String>,
    pub password: String,
}

impl User {
    pub fn new(name: String, avatar: Option<String>, password: String) -> Self {
        Self {
            name,
            avatar,
            password,
        }
    }
}
