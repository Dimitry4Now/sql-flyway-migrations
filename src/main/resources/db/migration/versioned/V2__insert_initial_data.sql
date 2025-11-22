INSERT INTO dime.users (username, email) VALUES
                                        ('john_doe', 'john@example.com'),
                                        ('jane_smith', 'jane@example.com'),
                                        ('bob_jones', 'bob@example.com');

INSERT INTO dime.posts (user_id, title, content, published) VALUES
                                                           (1, 'First Post', 'This is my first post!', true),
                                                           (1, 'Draft Post', 'This is a draft...', false),
                                                           (2, 'Hello World', 'Welcome to my blog', true),
                                                           (3, 'Learning Flyway', 'Flyway migrations are awesome!', true);