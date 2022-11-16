#[cfg(test)]
mod test {
    use blog::rocket as launch;
    use rocket;
    use rocket::http::{ContentType, Status};
    use rocket::local::blocking::Client;

    #[test]
    fn post_one_article() {
        let client = Client::tracked(launch()).expect("Valid rocket instance");
        let mut request = client.post("/api/v1/articles").body(
            r##"{
                    "uid": "test",
                    "title": "abc",
                    "content": "# blog  \n## A simple blog"
                }"##,
        );
        request.add_header(ContentType::JSON);
        let response = request.dispatch();

        assert_eq!(response.status(), Status::Ok);
        assert_eq!(response.into_string(), Some("Successful".into()));
    }
}
