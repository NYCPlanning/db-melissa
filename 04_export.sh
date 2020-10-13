#!/bin/bash
source config.sh

pg_dump -t melissa_output --no-owner $BUILD_ENGINE | psql $EDM_DATA
psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS dcp_melissa;";
psql $EDM_DATA -c "ALTER TABLE melissa_output SET SCHEMA dcp_melissa;";
psql $EDM_DATA -c "DROP TABLE IF EXISTS dcp_melissa.\"$DATE\";"
psql $EDM_DATA -c "ALTER TABLE dcp_melissa.melissa_output RENAME TO \"$DATE\";";