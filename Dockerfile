FROM eclipse-temurin:17-jdk

RUN apt-get update && apt-get install -y xz-utils unzip curl wget

WORKDIR /app
COPY . .

RUN chmod +x ./scripts/download-tools.sh && ./scripts/download-tools.sh
RUN chmod +x ./mvnw
RUN ./mvnw clean install

CMD ["java", "-jar", "target/convert-java-0.0.1-SNAPSHOT.jar"]
