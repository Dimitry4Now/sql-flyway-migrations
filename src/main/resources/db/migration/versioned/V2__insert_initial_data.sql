INSERT INTO dime.users (username, email) VALUES
                                        ('john_doe', 'john@example.com'),
                                        ('jane_smith', 'jane@example.com'),
                                        ('aco_kratovo', 'aco@kratovo.com'),
                                        ('teta_slavica', 'slavka@example.com'),
                                        ('chicho_miki', 'miksa@example.com'),
                                        ('le_bron', 'broun@example.com'),
                                        ('bond_james', 'jaem007@example.com'),
                                        ('kris_ti', 'tiKris@example.com'),
                                        ('go_lub', 'lub@example.com'),
                                        ('pinga_pinga', 'pinga@oof.com'),
                                        ('oof_bato', 'ba@to.com');

INSERT INTO dime.posts (user_id, title, content, published) VALUES
                                                           (1, 'First Post', 'This is my first post!', true),
                                                           (1, 'Draft Post', 'This is a draft...', false),
                                                           (2, 'Hello World', 'Welcome to my blog', true),
                                                           (3, 'Learning Flyway', 'Flyway migrations are awesome!', true);