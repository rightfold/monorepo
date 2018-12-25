-- Revert uphub:polls_table from pg

BEGIN;

DROP TABLE uphub.polls;

COMMIT;
