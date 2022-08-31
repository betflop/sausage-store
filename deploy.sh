#!/bin/bash
set -e
VAULT_TOKEN=${VAULT_TOKEN}
PSQL_DATASOURCE=${PSQL_DATASOURCE}
PSQL_USER=${PSQL_USER}
PSQL_PASSWORD=${PSQL_PASSWORD}
MONGO_DATA=${MONGO_DATA}

docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
docker-compose down --rmi local || true
docker-compose up -d vault

cat <<EOF | sudo docker exec -i vault ash
  sleep 20;
  vault login ${VAULT_TOKEN};
  vault kv put secret/sausage-store spring.data.mongodb.uri='${MONGO_DATA}' spring.datasource.username="${PSQL_USER}" spring.datasource.password="${PSQL_PASSWORD}" spring.datasource.url="${PSQL_DATASOURCE}";
EOF

docker-compose up -d
