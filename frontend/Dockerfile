FROM node:14.17.3-slim
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
COPY . .
RUN npm install && RUN npm install -g http-server && RUN npm run build
EXPOSE 80
ENTRYPOINT ["http-server", "dist/frontend/", "-p", "80", "--proxy", "http://backend:8888"]
