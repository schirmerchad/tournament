-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS matches;
DROP VIEW IF EXISTS winCount;
DROP VIEW IF EXISTS lossCount;
DROP VIEW IF EXISTS standings;

CREATE TABLE players 
(id SERIAL PRIMARY KEY, name TEXT);

CREATE TABLE matches 
(match_id SERIAL, winner INTEGER REFERENCES players(id), loser INTEGER REFERENCES players(id));

CREATE VIEW winCount 
AS SELECT id, name, COUNT(winner) AS wins 
FROM players LEFT JOIN matches 
ON players.id = matches.winner GROUP BY id;

CREATE VIEW lossCount 
AS SELECT id, name, COUNT(loser) AS losses 
FROM players LEFT JOIN matches 
ON players.id = matches.loser GROUP BY id;

--CREATE VIEW matchCount 
--AS SELECT id, name, COUNT(id) AS matches 
--FROM players LEFT JOIN matches 
--ON players.id = matches.winner or players.id = matches.loser GROUP BY id;

--CREATE VIEW standings 
--AS SELECT winCount.id, winCount.name, wins, matches 
--FROM winCount LEFT JOIN matchCount 
--ON winCount.id = matchCount.id ORDER BY wins DESC;

CREATE VIEW standings
AS SELECT winCount.id, winCount.name, wins, (winCount.wins + lossCount.losses) as matches
FROM winCount LEFT JOIN lossCount
ON winCount.id = lossCount.id ORDER BY wins DESC;