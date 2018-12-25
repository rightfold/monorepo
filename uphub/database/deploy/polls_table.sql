-- Deploy uphub:polls_table to pg
-- requires: monitors_table

BEGIN;

CREATE TABLE uphub.polls (
    monitor_id uuid                     NOT NULL,
    timestamp  TIMESTAMP WITH TIME ZONE NOT NULL,
    health     BOOLEAN                  NOT NULL,

    CONSTRAINT polls_pk
        PRIMARY KEY (monitor_id, timestamp),

    CONSTRAINT monitor_fk
        FOREIGN KEY (monitor_id)
        REFERENCES uphub.monitors (id)
        ON DELETE CASCADE
);

GRANT SELECT, INSERT, UPDATE, DELETE
    ON TABLE uphub.polls
    TO uphub_application;

COMMIT;
