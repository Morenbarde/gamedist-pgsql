-- Remove all project functions, tables, and views
DROP FUNCTION IF EXISTS add_user;
DROP FUNCTION IF EXISTS add_game;
DROP FUNCTION IF EXISTS start_game;

DROP VIEW IF EXISTS user_view;
DROP VIEW IF EXISTS game_library_view;
DROP VIEW IF EXISTS active_instances_view;
DROP VIEW IF EXISTS inactive_instances_view;
DROP VIEW IF EXISTS game_instances_view;

DROP TABLE IF EXISTS game_instances CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS game_library CASCADE;