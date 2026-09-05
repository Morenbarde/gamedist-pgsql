-- Creates sequence of database accesses to test main functionality
\i init.sql

\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'

-- Setup Game Library
SELECT add_game('Warframe');
SELECT add_game('Clair Obscur: Expedition 33');
SELECT add_game('Frostpunk');
\echo '--- Displaying Game Library ---'
SELECT * FROM game_library_view;

\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'


-- Adds one user
SELECT add_user('Player 1');
\echo '--- Displaying Users ---'
SELECT * FROM user_view;

\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'


-- Adds other users, Player 1 starts game session
SELECT add_user('Player 2');
SELECT add_user('Player ERR'); --Will Trigger error catching
\echo '--- Displaying Users ---'
SELECT * FROM user_view;
SELECT start_game('Player 1', 'Warframe');

\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'


-- Player 1 ends game session, Player 2 starts game session, Player ERR attempts to re-add
SELECT end_game('Player 1');
SELECT start_game('Player 2', 'Warframe');

\echo '### Attempted to add Player ERR again, should catch'
SELECT add_user('Player ERR');

\echo '--- Displaying All Game Instances ---'
SELECT * FROM game_instances_view;

\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'


-- Player 1 starts game session. Elayer ERR attempts to start unkown game, and close game
SELECT start_game('Player 1', 'Frostpunk');
\echo '### Player ERR attempts to run Minecraft, should catch'
SELECT start_game('Player ERR', 'Minecraft');
\echo '### Player ERR attempts to stop game instance, should catch'
SELECT end_game('Player ERR');

\echo '--- Displaying All Game Instances ---'
SELECT * FROM game_instances_view;

\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'


-- Player ERR starts game session, Player 2 ends one
SELECT start_game('Player ERR', 'Clair Obscur: Expedition 33');
SELECT end_game('Player 2');

\echo '--- Displaying All Game Instances ---'
SELECT * FROM game_instances_view;

\echo '--- Displaying Game Library ---'
SELECT * FROM game_library_view;


\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'

-- Player ERR and 2 Start game instances
\echo '### Player ERR attempts to start 2 additional game instances, should catch'
SELECT start_game('Player ERR', 'Warframe');
SELECT start_game('Player ERR', 'Clair Obscur: Expedition 33');
SELECT start_game('Player 2', 'Frostpunk');

\echo '--- Displaying All Game Instances ---'
SELECT * FROM game_instances_view;

\echo '--- Displaying Active Game Instances ---'
SELECT * FROM active_instances_view;;

\echo '--- Displaying Inactive Game Instances ---'
SELECT * FROM inactive_instances_view;


\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'


-- Player 1 Ends Game
SELECT end_game('Player 1');


\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'


-- Players 2 and ERR End Games
SELECT end_game('Player 2');
SELECT end_game('Player ERR');

\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'

\echo '--- Displaying Users ---'
SELECT * FROM user_view;
\echo '--- Displaying Game Library ---'
SELECT * FROM game_library_view;
\echo '--- Displaying All Game Instances ---'
SELECT * FROM game_instances_view;
\echo '--- Displaying Active Game Instances ---'
SELECT * FROM active_instances_view;
\echo '--- Displaying Inactive Game Instances ---'
SELECT * FROM inactive_instances_view;

\echo ''
\prompt 'Press Enter To Continue' mystr
\echo '\n\n\n\n\n\n'

\echo '--- Displaying Full Tables ---\n'
SELECT * FROM users;
SELECT * FROM game_library;
SELECT * FROM game_instances;