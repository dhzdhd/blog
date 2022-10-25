CREATE TABLE
    articles (
        id VARCHAR PRIMARY KEY,
        title VARCHAR UNIQUE NOT NULL,
        content VARCHAR NOT NULL
    );
