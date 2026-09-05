-- Create tables

CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    time_created TIMESTAMP
);

CREATE TABLE IF NOT EXISTS game_library (
    game_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE, -- Implemented as unique for this project for simplicity
    time_played INTERVAL -- Total time played by all users
);

CREATE TABLE IF NOT EXISTS game_instances (
    id SERIAL PRIMARY KEY,
    user_id integer REFERENCES users(user_id),
    game_id integer REFERENCES game_library (game_id),
    start_time TIMESTAMP,
    end_time TIMESTAMP
);