#!/bin/bash

set +e
cat > .env <<EOF
SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL}
SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME}
SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD}
SPRING_DATA_MONGODB_URI=${SPRING_DATA_MONGODB_URI}
EOF
docker network create -d bridge sausage_network || true
#docker login gitlab.praktikum-services.ru:5050 -u ${USER_REGISTRY} -p ${PASSWORD_REGISTRY}
echo 1
echo ${USER_REGISTRY}
echo ${PASSWORD_REGISTRY}

docker login -u ${CI_REGISTRY_USER} -p ${CI_REGISTRY_PASSWORD} ${CI_REGISTRY}
echo 2
echo ${CI_REGISTRY_USER} 
echo ${CI_REGISTRY_PASSWORD} 
echo ${CI_REGISTRY}

docker pull ${CI_REGISTRY}/d.pashkov/sausage-store/sausage-backend:latest
docker stop backend || true
docker rm backend || true

set -e
docker run -d --name backend \
    --network=sausage_network \
    --restart always \
    --pull always \
    --env-file .env \
    ${CI_REGISTRY}/d.pashkov/sausage-store/sausage-backend:latest
