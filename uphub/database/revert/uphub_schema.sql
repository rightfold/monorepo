-- Revert uphub:uphub_schema from pg

BEGIN;

DROP SCHEMA uphub;

COMMIT;
