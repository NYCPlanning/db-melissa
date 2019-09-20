DB_CONTAINER_NAME=melissa

docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -f sql/create.sql
docker exec $DB_CONTAINER_NAME psql -U postgres -h localhost -f sql/fill.sql