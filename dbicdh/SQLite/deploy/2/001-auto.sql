-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon May  1 14:12:15 2017
-- 

;
BEGIN TRANSACTION;
--
-- Table: character
--
CREATE TABLE character (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL
);
--
-- Table: inventory
--
CREATE TABLE inventory (
  id INTEGER PRIMARY KEY NOT NULL,
  character_id integer NOT NULL,
  item_id integer NOT NULL,
  qty integer NOT NULL
);
--
-- Table: item
--
CREATE TABLE item (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  cost integer NOT NULL,
  currency varchar NOT NULL
);
COMMIT;
