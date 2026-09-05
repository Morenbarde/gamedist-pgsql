-- Display Views

CREATE VIEW user_view AS 
    SELECT username AS user, time_created FROM users;


CREATE VIEW game_library_view AS
    SELECT name AS game, time_played FROM game_library;


CREATE VIEW game_instances_view AS
    SELECT u.username AS user, c.name AS game, c.start_time, c.end_time,
        CASE WHEN (c.end_time IS NULL) THEN (AGE(NOW(), c.start_time))
                     ELSE (AGE(c.end_time, c.start_time))
        END AS runtime
    FROM users u JOIN (
        SELECT * FROM game_library g Join game_instances i
        ON g.game_id = i.game_id) c
    ON u.user_id = c.user_id
    ORDER BY c.end_time DESC, start_time DESC;


CREATE VIEW active_instances_view AS
    SELECT user, game, start_time, runtime FROM game_instances_view
    WHERE end_time IS NULL
    ORDER BY start_time DESC;

CREATE VIEW inactive_instances_view AS
    SELECT * FROM game_instances_view
    WHERE end_time IS NOT NULL
    ORDER BY end_time DESC;