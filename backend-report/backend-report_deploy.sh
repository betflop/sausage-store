#!/bin/bash
set +e
cat > .env <<EOF
VAULT_TOKEN=${VAULT_TOKEN}
VAULT_URL=${VAULT_URL}
REPORT_PATH=/app/log/reports
LOG_PATH=/app/log
EOF

docker network create -d bridge sausage_network || true
docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
docker pull $CI_REGISTRY_IMAGE/sausage-backend-report:latest
docker-compose pull
docker-compose --env-file .env up -d backend-report
