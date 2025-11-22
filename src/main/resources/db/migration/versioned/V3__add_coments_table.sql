CREATE TABLE dime.comments (
                          id BIGSERIAL PRIMARY KEY,
                          post_id BIGINT NOT NULL,
                          user_id BIGINT NOT NULL,
                          content TEXT NOT NULL,
                          created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          CONSTRAINT fk_comments_post FOREIGN KEY (post_id) REFERENCES dime.posts(id) ON DELETE CASCADE,
                          CONSTRAINT fk_comments_user FOREIGN KEY (user_id) REFERENCES dime.users(id) ON DELETE CASCADE
);

CREATE INDEX idx_comments_post_id ON dime.comments(post_id);
CREATE INDEX idx_comments_user_id ON dime.comments(user_id);