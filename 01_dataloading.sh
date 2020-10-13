#!/bin/bash
source config.sh
## load data into the ztl container
docker run --rm\
    -v $(pwd)/python:/home/python\
    -w /home/python\
    -e BUILD_ENGINE=$BUILD_ENGINE\
    -e RECIPE_ENGINE=$RECIPE_ENGINE\
    nycplanning/cook:latest python3 dataloading.py

psql $BUILD_ENGINE -f sql/preprocessing.sql