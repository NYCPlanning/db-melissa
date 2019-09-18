docker run --rm\
    --network=host\
    -v `pwd`:/home/db-melissa\
    -w /home/db-melissa\
    --env-file .env\
    sptkl/docker-geosupport:19b2 bash -c "pip3 install -r requirements.txt; python3 python/geocoding.py"
