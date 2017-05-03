-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Tue May  2 15:40:48 2017
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
-- Table: source
--
CREATE TABLE source (
  id INTEGER PRIMARY KEY NOT NULL,
  type varchar,
  name varchar NOT NULL
);
--
-- Table: item
--
CREATE TABLE item (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  category varchar,
  type varchar,
  subtype varchar,
  cost varchar,
  currency varchar,
  weight varchar,
  desc varchar,
  source_id integer,
  FOREIGN KEY (source_id) REFERENCES source(id)
);
CREATE INDEX item_idx_source_id ON item (source_id);
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
