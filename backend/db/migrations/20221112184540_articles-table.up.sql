-- sqlx migrate run --database-url postgres://postgres:postgres@localhost:5432/blog --source ./db/migrations\

CREATE TABLE
    articles (
        id VARCHAR PRIMARY KEY,
        title VARCHAR UNIQUE NOT NULL,
        content TEXT NOT NULL,
        created_at DATE NOT NULL DEFAULT CURRENT_DATE
    );

CREATE TABLE
    users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        avatar TEXT NOT NULL,
        password TEXT NOT NULL
    );
