CREATE SCHEMA IF NOT EXISTS dime;

CREATE TABLE dime.users (
                       id BIGSERIAL PRIMARY KEY,
                       username VARCHAR(100) NOT NULL UNIQUE,
                       email VARCHAR(255) NOT NULL UNIQUE,
                       created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dime.posts (
                       id BIGSERIAL PRIMARY KEY,
                       user_id BIGINT NOT NULL,
                       title VARCHAR(255) NOT NULL,
                       content TEXT,
                       published BOOLEAN NOT NULL DEFAULT FALSE,
                       created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       CONSTRAINT fk_posts_user FOREIGN KEY (user_id) REFERENCES dime.users(id) ON DELETE CASCADE
);

CREATE INDEX idx_posts_user_id ON dime.posts(user_id);
CREATE INDEX idx_posts_published ON dime.posts(published);
CREATE INDEX idx_users_email ON dime.users(email);
