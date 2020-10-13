#!/bin/bash
source config.sh

psql $BUILD_ENGINE -f sql/create.sql
psql $BUILD_ENGINE -f sql/fill.sql
psql $BUILD_ENGINE -f sql/output.sql
# psql $BUILD_ENGINE -f sql/clean.sql