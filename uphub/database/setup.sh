#!/usr/bin/env bash

# TODO: Make this script idempotent so it can be run more than once.

if [[ "$(whoami)" != 'postgres' ]]; then
    >&2 echo "$0 must run as 'postgres', not as '$(whoami)'."
    exit 1
fi

psql <<'EOF'
    CREATE ROLE uphub_application LOGIN PASSWORD 'uphub_application';
    CREATE ROLE uphub_migrations LOGIN PASSWORD 'uphub_migrations';
    CREATE DATABASE uphub_test OWNER uphub_migrations;
EOF

PGDATABASE=uphub_test psql <<'EOF'
    DROP SCHEMA public;
EOF
