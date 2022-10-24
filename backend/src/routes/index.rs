#[get("/")]
pub async fn index() -> &'static str {
    "
    USAGE

        POST /blogs/<name>
            accepts title and content and stores it as a blog post

        GET /blogs/<id>
            retrieve a post with name `<name>`

        GET /blogs
            retrieves all posts

        DELETE /blogs/<name>
            deletes the post by name
    "
}
