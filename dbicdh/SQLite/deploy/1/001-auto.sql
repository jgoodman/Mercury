-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Mon May  1 13:22:32 2017
-- 

;
BEGIN TRANSACTION;
--
-- Table: inventory
--
CREATE TABLE inventory (
  id INTEGER PRIMARY KEY NOT NULL,
  character_id integer NOT NULL,
  item_id integer NOT NULL,
  qty integer NOT NULL
);
COMMIT;
