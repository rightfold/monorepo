-- Deploy uphub:uphub_schema to pg

BEGIN;

CREATE SCHEMA uphub;

GRANT USAGE
    ON SCHEMA uphub
    TO uphub_application;

COMMIT;
