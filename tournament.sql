-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

CREATE TABLE players 
(id SERIAL PRIMARY KEY, name TEXT NOT NULL);

CREATE TABLE matches 
  (match_id SERIAL,
  winner INT REFERENCES players(id) ON DELETE CASCADE,
  loser INT REFERENCES players(id) ON DELETE CASCADE,
  CHECK (winner <> loser));

CREATE VIEW winCount AS
  SELECT id,
         name,
         COUNT(winner) AS wins 
  FROM players
  LEFT JOIN matches 
    ON players.id = matches.winner
  GROUP BY id;

CREATE VIEW lossCount AS
  SELECT id,
        name,
        COUNT(loser) AS losses 
  FROM players
  LEFT JOIN matches 
    ON players.id = matches.loser
  GROUP BY id;

CREATE VIEW standings AS
  SELECT winCount.id,
         winCount.name,
         wins,
         (winCount.wins + lossCount.losses) as matches
  FROM winCount
  LEFT JOIN lossCount
    ON winCount.id = lossCount.id
  ORDER BY wins DESC;
