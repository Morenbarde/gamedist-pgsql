# GameDist-pgsql
This projects defines a simple database for keeping track of a game distribution site's users, games, and game usage. This was designed as a personal project to familiarize myself with PostgreSQL.


## Motivation

I chose this project partially because I wanted to learn PostgreSQL, and also because I am a long-time steam user who has interest in the mechanisms used to manage game distribution. My original plan for this project was to use the steam api to populate tables with a user's data, but I changed my plan after realizing:

- That plan would not be very interactive, as it would just be populating a table with data, rather than doing anything interesting with that data
- That would require signing up for a steam api key to use, which I believe is outside the intended scope of this project

To learn the technology, I primarily used the [PostgreSQL Documentation](https://www.postgresql.org/docs/18/index.html), going through their tutorial and referencing other pages as needed. I also referenced GeeksForGeeks and StackExchange for specific problems, and did additional experimentation to check behavior. In addition, I wrote a test script to make sure the main components of the database work as intended, which also doubles as a demonstration.

The database itself only has 3 tables for tracking users, a system-wide game library, and gameplay instances. It includes functions for adding games and users, and starting and stopping game instances. It also has several views to give better informed information about the tables.

This database is a very simplistic version of such a product. In the future, I would like to add systems for user libraries, game achievements, and other expansions to fill out the system.

## Reqirements

This project was designed with PostgreSQL version 16.15 on Ubuntu 24.04

## Installation

Clone and navigate into the repository
```
git clone https://github.com/Morenbarde/gamedist-pgsql.git
cd gamedist-pgsql
```

The database can be initialized by running the init.sql file in the psql command line. 

**NOTE:** This script will also remove and overwrite previous definitions of tables, view, and functions. It is recommended that this repository is used in a new PostgreSQL database instance.
```
psql
```
```
\i init.sql
```

## Demonstration

The repository also includes a test script which simulates a sequence of interactions with the database to test its functionality. This script automatically runs the initialization script beforehand.

```
\i test_script.sql
```

## Structure

### Tables

The database consists of 3 tables. These are defined in [src/initialize_tables.sql](src/initialize_tables.sql)

```
users: 
    id
    username
    time_created

game_libarary:
    game_id
    name
    time_played

game_instances
    id
    user_id REFERENCES users(user_id)
    game_id REFERENCES game_library (game_id)
    start_time
    end_time
```



### Views

The database includes 5 views for cleaner access to the information. These are defined in [src/initialize_views.sql](src/initialize_views.sql). These views will provide table information in the following formats:

#### user_view
```
    user    |         time_created        
------------+-----------------------------
  username  |  2026-09-01 00:00:00:000000 
```

#### game_library_view
```
     game     |   time_played   
--------------+-----------------
  Game Title  | 00:00:00.000000
```

#### game_instances_view
```
    user    |     game     |         start_time         |          end_time          |     runtime     
------------+--------------+----------------------------+----------------------------+-----------------
  username  |  Game Title  | 2026-09-01 00:00:00:000000 | 2026-09-01 00:00:00:000000 | 00:00:00.000000
```

#### active_instances_view
Shows all game instances that have not been finished, shows runtime since started
```
    user    |     game     |         start_time         |     runtime     
------------+--------------+----------------------------+-----------------
  username  |  Game Title  | 2026-09-01 00:00:00:000000 | 00:00:00.000000
```

#### inactive_instances_view
Shows all game instances that have been finished, shows total runtime
```
    user    |     game     |         start_time         |          end_time          |     runtime     
------------+--------------+----------------------------+----------------------------+-----------------
  username  |  Game Title  | 2026-09-01 00:00:00:000000 | 2026-09-01 00:00:00:000000 | 00:00:00.000000
```


### Functions

All functions are defined in [src/initialize_functions.sql](src/initialize_functions.sql).

#### add_user
Registers a new user with the distribution system. Fails if the user name is already in use.
```
add_user(name TEXT)
```

#### add_game
Adds a new game to the system-wide game library. Fails if another game with the same name is already in the library. This is for simplicity for now, but would like to change in the future.
```
add_game(name TEXT)
```

#### start_game
Begins a game instance. Fails if the username is not registered, the game does not exist in the library, or if the user is already in another game instance.
```
start_game(local_username TEXT, game TEXT) 
```

#### end_game
Finished the user's active game instance. Fails if the username is not registered or if the user does not have an active game instance.
```
end_game(local_username TEXT)
```