FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY . .

# Cấp quyền cho các file thực thi
RUN chmod +x ./mvnw && chmod +x ./scripts/download-tools.sh

# Tải công cụ
RUN ./scripts/download-tools.sh

# Build project
RUN ./mvnw clean install

# Run ứng dụng
CMD ["java", "-jar", "target/convert-java-0.0.1-SNAPSHOT.jar"]
