DB_CONTAINER_NAME=melissa

docker run --rm\
    --network=host\
    -v `pwd`:/home/db-melissa\
    -w /home/db-melissa\
    --env-file .env\
    sptkl/docker-geosupport:19c bash -c "pip3 install -r requirements.txt; python3 python/geocoding.py"

docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -c "
    DROP TABLE IF EXISTS melissa_input_geocode;
    CREATE TABLE melissa_input_geocode (
        a_WA1_HouseNumberDisplay text,
        a_WA1_STREET1_StreetName text,
        a_WA1_Message text,
        a_WA2_BBL text,
        a_WA2_BinOfInputAddress text,
        a_WA2_TPADNewBin text,
        a_WA2_ReasonCode text,
        a_WA2_GRC text,
        e_WA1_HouseNumberDisplay text,
        e_WA1_STREET1_BoroughCode text,
        e_WA1_STREET1_StreetName text,
        e_WA1_Message text,
        e_WA2_XCoordinate text,
        e_WA2_YCoordinate text,
        e_WA2_CommunityDistrict text,
        e_WA2_NTA text,
        e_WA2_PhysicalID text,
        e_WA2_NTAname text,
        e_WA2_Latitude text,
        e_WA2_Longitude text,
        e_WA2_BlockfaceID text,
        e_WA2_ReasonCode text,
        e_WA2_GRC text,
        ap_WA1_HouseNumberDisplay text,
        ap_WA1_STREET1_StreetName text,
        ap_WA2_GRC text,
        ap_WA2_ReasonCode text,
        ap_WA1_Message text,
        ap_WA2_Latitude text,
        ap_WA2_Longitude text,
        ap_WA2_XCoordinate text,
        ap_WA2_YCoordinate text,
        ap_WA2_AP_ID text,
        id text
    );
    DROP TABLE IF EXISTS melissa_corrections_geocode;
    CREATE TABLE melissa_corrections_geocode AS (SELECT * FROM melissa_input_geocode);
"
docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -c "
    COPY melissa_input_geocode 
    FROM '/home/db-melissa/output/melissa_input_geocode.csv' 
    WITH NULL AS '' 
    DELIMITER ',' 
    CSV HEADER;
"
docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -c "
    COPY melissa_corrections_geocode 
    FROM '/home/db-melissa/output/melissa_corrections_geocode.csv' 
    WITH NULL AS '' 
    DELIMITER ',' 
    CSV HEADER;
"
# docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -f sql/postprocessing.sql