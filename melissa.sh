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

case $1 in 
    dataloading) 
        mc cp spaces/edm-private/MelissaData2021.zip .
        rm -rf data && mkdir -p data && unzip MelissaData2021.zip -d data && rm MelissaData2021.zip
        psql $BUILD_ENGINE -f sql/preprocessing.sql
        python3 -m python.dataloading
        ;;
    build)
        psql $BUILD_ENGINE -f sql/create.sql
        psql $BUILD_ENGINE -f sql/fill.sql
        psql $BUILD_ENGINE -f sql/output.sql
        ;;
    geocoding)
        mkdir -p output
        docker run --rm\
        -v $(pwd):/home/db-melissa\
        -w /home/db-melissa\
        -e BUILD_ENGINE=$BUILD_ENGINE\
        nycplanning/docker-geosupport:latest bash -c "pip3 install -r requirements.txt; python3 python/geocoding.py"
        ;;
    export) 
        pg_dump -t melissa_output --no-owner $BUILD_ENGINE | psql $EDM_DATA
        psql $EDM_DATA -c "CREATE SCHEMA IF NOT EXISTS dcp_melissa;";
        psql $EDM_DATA -c "ALTER TABLE melissa_output SET SCHEMA dcp_melissa;";
        psql $EDM_DATA -c "DROP TABLE IF EXISTS dcp_melissa.\"$DATE\";"
        psql $EDM_DATA -c "ALTER TABLE dcp_melissa.melissa_output RENAME TO \"$DATE\";";
        ;;
    *)
        echo 
        echo "Command $1 not found, do ./melissa.sh dataloading|geocoding|build|export"
        echo
        ;;
esac