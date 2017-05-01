-- Convert schema '/Users/kagoodman/repos/github/Mercury/script/../dbicdh/_source/deploy/1/001-auto.yml' to '/Users/kagoodman/repos/github/Mercury/script/../dbicdh/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE character (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL
);

;
CREATE TABLE item (
  id INTEGER PRIMARY KEY NOT NULL,
  name varchar NOT NULL,
  cost integer NOT NULL,
  currency varchar NOT NULL
);

;

COMMIT;

