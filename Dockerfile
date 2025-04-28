FROM eclipse-temurin:17-jdk

WORKDIR /app
COPY . .

RUN chmod +x ./mvnw
RUN ./mvnw clean install

CMD ["java", "-jar", "target/convert-java-0.0.1-SNAPSHOT.jar"]
