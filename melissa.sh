#!/bin/bash
DATE=$(date "+%Y-%m-%d")

function set_env {
  for envfile in $@
  do
    if [ -f $envfile ]
      then
        export $(cat $envfile | sed 's/#.*//g' | xargs)
      fi
  done
}
set_env .env

function CSV_export {
    local tablename=$1
    local filename=${2:-$tablename}
    psql $BUILD_ENGINE  -c "\COPY (
        SELECT * FROM $tablename
    ) TO STDOUT DELIMITER ',' CSV HEADER;" > $filename.csv
}

function upload {
    local branchname=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
    local DATE=$(date "+%Y-%m-%d")
    local SPACES="spaces/edm-private/db-melissa/$branchname"
    local HASH=$(git describe --always)
    mc rm -r --force $SPACES/latest
    mc rm -r --force $SPACES/$DATE
    mc rm -r --force $SPACES/$HASH
    mc cp --attr acl=private -r output $SPACES/latest
    mc cp --attr acl=private -r output $SPACES/$DATE
    mc cp --attr acl=private -r output $SPACES/$HASH
}

case $1 in 
    install)
        pip install -r requirements.txt
        ;;
    dataloading) 
        mc cp spaces/edm-private/MelissaData2021.zip .
        rm -rf data && mkdir -p data && unzip MelissaData2021.zip -d data && rm MelissaData2021.zip
        python3 -m python.dataloading
        psql $BUILD_ENGINE -f sql/preprocessing.sql
        ;;
    build)
        psql $BUILD_ENGINE -f sql/create.sql
        psql $BUILD_ENGINE -f sql/fill.sql
        psql $BUILD_ENGINE -f sql/output.sql
        ;;
    geocoding)
        python3 -m python.geocoding
        ;;
    export) 
        pg_dump -t melissa_output --no-owner $BUILD_ENGINE | psql $EDM_DATA
        psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS dcp_melissa;";
        psql $EDM_DATA -c "ALTER TABLE melissa_output SET SCHEMA dcp_melissa;";
        psql $EDM_DATA -c "DROP TABLE IF EXISTS dcp_melissa.\"$DATE\";"
        psql $EDM_DATA -c "ALTER TABLE dcp_melissa.melissa_output RENAME TO \"$DATE\";";

        mkdir -p output && (
            cd output
            CSV_export melissa
            zip melissa.zip melissa.csv
            rm melissa.csv
        )
        upload
        ;;
    *)
        echo 
        echo "Command $1 not found, do ./melissa.sh install|dataloading|geocoding|build|export"
        echo
        ;;
esac
