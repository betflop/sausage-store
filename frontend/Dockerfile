FROM node:14.17.3-alpine as builder
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm run build

FROM nginxproxy/nginx-proxy:alpine
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html
COPY --from=builder /usr/src/app/nginx.tmpl /app/nginx.tmpl
EXPOSE 80
