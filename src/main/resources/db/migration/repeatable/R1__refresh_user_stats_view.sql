CREATE OR REPLACE VIEW dime.user_stats AS
SELECT
    u.id,
    u.username,
    u.email,
    COUNT(DISTINCT p.id) as total_posts,
    COUNT(DISTINCT CASE WHEN p.published = true THEN p.id END) as published_posts,
    COUNT(DISTINCT CASE WHEN p.published = false THEN p.id END) as draft_posts,
    COUNT(DISTINCT c.id) as total_comments,
    MAX(p.created_at) as last_post_date,
    u.created_at as user_since
FROM dime.users u
         LEFT JOIN dime.posts p ON u.id = p.user_id
         LEFT JOIN dime.comments c ON u.id = c.user_id
GROUP BY u.id, u.username, u.email, u.created_at;