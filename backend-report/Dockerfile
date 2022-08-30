FROM maven:3.8-openjdk-16 as builder
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
COPY . .
RUN mvn package -DskipTests -Dversion.application=${VERSION}

FROM openjdk:16
ARG VERSION=${VERSION}
WORKDIR /usr/src/app
RUN curl https://storage.yandexcloud.net/cloud-certs/CA.pem -o YandexInternalRootCA.crt && \
    keytool -importcert -file YandexInternalRootCA.crt -alias yandex -cacerts -storepass changeit -noprompt && \
    rm -f YandexInternalRootCA.crt
COPY --from=builder /usr/src/app/target/sausage-store-report-${VERSION}.jar sausage-store-report.jar
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "./sausage-store-report.jar", "--service.port=8081"]
