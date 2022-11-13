-- sqlx migrate run --database-url postgres://postgres:postgres@localhost:5432/blog --source ./db/migrations\

CREATE TABLE
    articles (
        id VARCHAR PRIMARY KEY,
        title VARCHAR UNIQUE NOT NULL,
        content VARCHAR NOT NULL,
        created_at DATE NOT NULL DEFAULT CURRENT_DATE
    )
