-- sqlx migrate revert --database-url postgres://postgres:postgres@localhost:5432/blog --source ./db/migrations\

DROP TABLE IF EXISTS articles;

DROP TABLE IF EXISTS users;
