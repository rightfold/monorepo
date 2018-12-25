-- Deploy uphub:schedule_view to pg
-- requires: polls_table

BEGIN;

CREATE VIEW uphub.schedule AS
    SELECT monitors.id AS monitor_id
    FROM uphub.monitors
    LEFT OUTER JOIN uphub.polls
        ON polls.monitor_id = monitors.id
    GROUP BY monitors.id
    HAVING
        count(polls.*) = 0 OR
        now() - max(polls.timestamp) >= monitors.interval;

GRANT SELECT
    ON TABLE uphub.schedule
    TO uphub_application;

COMMIT;
