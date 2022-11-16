#[derive(Serialize, Deserialize)]
pub struct User {
    pub name: String,
    pub avatar: Option<String>,
}
