#!/bin/bash
set -e

docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
docker-compose down --rmi local
docker-compose up -d vault

cat <<EOF | docker exec -i vault ash
  sleep 10;
  vault login ${VAULT_TOKEN}
  #vault secrets enable -path=secret kv
  vault kv put secret/sausage-store spring.data.mongodb.uri="${MONGO_DATA}" spring.datasource.username="${PSQL_USER}" spring.datasource.password="${PSQL_PASSWORD}" spring.datasource.url="${PSQL_DATASOURCE}"
EOF

docker-compose up -d
