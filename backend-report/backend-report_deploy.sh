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
docker stop backend-report || true
docker rm backend-report || true

set -e
docker run -d --name backend-report \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    -p 8081:8081 \
    $CI_REGISTRY_IMAGE/sausage-backend-report:latest
