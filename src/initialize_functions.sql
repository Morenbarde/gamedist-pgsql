-- Define functions

-- ADD to databases
CREATE OR REPLACE FUNCTION add_user(name TEXT) RETURNS TEXT AS $$
BEGIN
    IF name IN (SELECT username FROM users) THEN
        RETURN 'ERROR: Username already in use, choose another.';
    END IF;

    INSERT INTO users (username, time_created)
    VALUES (name, NOW());

    RETURN CONCAT('CREATED NEW USER: ', name);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION add_game(name TEXT) RETURNS TEXT AS $$
BEGIN
    IF name IN (SELECT username FROM users) THEN
        RETURN 'ERROR: Game already in library';
    END IF;

    INSERT INTO game_library (name, time_played)
    VALUES (name, '0 days');

    RETURN CONCAT('CREATED NEW GAME: ', name);
END
$$ LANGUAGE plpgsql;


-- Start Game Instance
CREATE OR REPLACE FUNCTION start_game(local_username TEXT, game TEXT) RETURNS TEXT AS $$
DECLARE
    local_uid integer;
    local_gid integer;
BEGIN
    -- Get user and game id, enforce validity of both
    SELECT user_id INTO local_uid FROM users WHERE username = local_username;
    IF (local_uid IS NULL) THEN
        RETURN 'ERROR: User name not registered, use add_user() to add to database';
    END IF;

    SELECT game_id INTO local_gid FROM game_library WHERE game_library.name = game;
    IF (local_gid IS NULL) THEN
        RETURN 'ERROR: Game not in library, use add_game() to add to database';
    END IF;

    -- Check for active game instance
    IF local_uid IN (SELECT user_id FROM game_instances WHERE end_time IS NULL) THEN
        RETURN 'ERROR: User is already running a game, use end_game() to end game instance';
    END IF;

    -- Add new game instance
    INSERT INTO game_instances (user_id, game_id, start_time)
    VALUES (local_uid, local_gid, NOW());

    RETURN CONCAT('ADDED GAME INSTANCE WITH USER: ', local_username, '   GAME: ', game);
END
$$ LANGUAGE plpgsql;


-- End Game Instance
CREATE OR REPLACE FUNCTION end_game(local_username TEXT) RETURNS TEXT AS $$
DECLARE
    local_uid integer;
    instance RECORD;
    cur_time TIMESTAMP = NOW();
BEGIN
    -- Get user id, enforce validity
    SELECT user_id INTO local_uid FROM users WHERE username = local_username;
    IF (local_uid IS NULL) THEN
        RETURN 'ERROR: User name not registered';
    END IF;

    -- Check for and retrieve active game instance
    SELECT * into instance FROM game_instances WHERE (user_id = local_uid) AND (end_time IS NULL);
    IF (instance IS NULL) THEN
        RETURN 'ERROR: No game instances running';
    END IF;

    -- Remove game instance
    UPDATE game_instances
        SET end_time = cur_time
        WHERE (game_instances.id = instance.id);

    UPDATE game_library
        SET time_played = time_played + AGE(cur_time, instance.start_time)
        WHERE (game_library.game_id = instance.game_id);

    RETURN CONCAT(local_username, ' ended game instance');
END
$$ LANGUAGE plpgsql;