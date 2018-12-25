-- Revert uphub:schedule_view from pg

BEGIN;

DROP VIEW uphub.schedule;

COMMIT;
