-- Revert uphub:monitors_table from pg

BEGIN;

DROP TABLE uphub.monitors;

COMMIT;
