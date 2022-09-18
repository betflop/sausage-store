FROM node:14.17.3-alpine as builder
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
COPY . .
RUN npm install && npm run build

FROM nginx:1.23.1-alpine
COPY --from=builder /usr/src/app/dist/frontend /usr/share/nginx/html
EXPOSE 8080
