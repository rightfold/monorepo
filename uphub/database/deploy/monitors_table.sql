-- Deploy uphub:monitors_table to pg
-- requires: uphub_schema

BEGIN;

CREATE TABLE uphub.monitors (
    id           uuid              NOT NULL,
    interval     INTERVAL          NOT NULL,
    mechanism    "char"            NOT NULL,
    http_url     CHARACTER VARYING,
    http_timeout INTERVAL,
    ping_host    CHARACTER VARYING,
    ping_timeout INTERVAL,

    CONSTRAINT monitors_pk
        PRIMARY KEY (id),

    CONSTRAINT mechanism_chk
        CHECK (mechanism IN ('H', 'P')),

    CONSTRAINT http_chk
        CHECK (num_nulls(http_url, http_timeout) =
                   2 * CAST(mechanism <> 'H' AS INTEGER)),

    CONSTRAINT ping_chk
        CHECK (num_nulls(ping_host, ping_timeout) =
                   2 * CAST(mechanism <> 'P' AS INTEGER))
);

GRANT SELECT, INSERT, UPDATE, DELETE
    ON TABLE uphub.monitors
    TO uphub_application;

COMMIT;
