FROM eclipse-temurin:17-jdk

# Tạo thư mục làm việc
WORKDIR /app

# Copy toàn bộ project vào container
COPY . .

# Tải công cụ yt-dlp và ffmpeg
RUN chmod +x ./scripts/download-tools.sh && ./scripts/download-tools.sh

# Build project với Maven Wrapper (hoặc mvn nếu dùng global)
RUN ./mvnw clean install

# Chạy app
CMD ["java", "-jar", "target/convert-java-0.0.1-SNAPSHOT.jar"]
