-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon May  1 19:06:52 2017
-- 

;
BEGIN TRANSACTION;
--
-- Table: character
--
CREATE TABLE character (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  purse integer NOT NULL
);
--
-- Table: item
--
CREATE TABLE item (
  id INTEGER PRIMARY KEY NOT NULL,
  type varchar,
  name varchar NOT NULL,
  cost integer,
  currency varchar,
  weight varchar,
  desc varchar
);
--
-- Table: item_meta
--
CREATE TABLE item_meta (
  id INTEGER PRIMARY KEY NOT NULL,
  item_id integer NOT NULL,
  name varchar NOT NULL,
  value varchar NOT NULL,
  FOREIGN KEY (item_id) REFERENCES item(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX item_meta_idx_item_id ON item_meta (item_id);
--
-- Table: inventory
--
CREATE TABLE inventory (
  id INTEGER PRIMARY KEY NOT NULL,
  character_id integer NOT NULL,
  item_id integer NOT NULL,
  qty integer NOT NULL,
  FOREIGN KEY (character_id) REFERENCES character(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (item_id) REFERENCES item(id)
);
CREATE INDEX inventory_idx_character_id ON inventory (character_id);
CREATE INDEX inventory_idx_item_id ON inventory (item_id);
COMMIT;
