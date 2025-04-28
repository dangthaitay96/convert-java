FROM openjdk:17
COPY target/app.jar app.jar
ENV SPRING_PROFILES_ACTIVE=prod
CMD ["java", "-jar", "app.jar"]
