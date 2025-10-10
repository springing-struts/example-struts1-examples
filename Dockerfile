FROM docker.io/azul/zulu-openjdk:21.0.8-21.44
WORKDIR /app
COPY target/extracted/dependencies/ ./
COPY target/extracted/spring-boot-loader/ ./
COPY target/extracted/snapshot-dependencies/ ./
COPY target/extracted/application/ ./
COPY entrypoint.sh ./

ENTRYPOINT ["./entrypoint.sh"]
