#!/bin/bash
set +e

cat > .env <<EOF
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
#SPRING_DATA_MONGODB_URI=${MONGO_DATA}
SPRING_DATA_MONGODB_URI=mongodb://sudmedru:Testusr1234@rc1b-k6kxnzzdzwda1z36.mdb.yandexcloud.net:27018/sudmedru?tls=true&replicaSet=rs01
REPORT_PATH=/app/log/reports
LOG_PATH=/app/log
EOF

docker network create -d bridge sausage_network || true
docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
docker pull ${CI_REGISTRY}/d.pashkov/sausage-store/sausage-backend:latest
docker stop backend || true
docker rm backend || true

set -e
docker run -d --name backend \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    -p 8888:8888 \
    ${CI_REGISTRY}/d.pashkov/sausage-store/sausage-backend:latest
