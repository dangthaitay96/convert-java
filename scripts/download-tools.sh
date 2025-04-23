#!/bin/bash

echo "👉 Bắt đầu tải yt-dlp và ffmpeg cho Linux..."

# Đường dẫn nơi app sẽ load file nhị phân
TARGET="src/main/resources/bin"

# 1. Tải yt-dlp
mkdir -p "$TARGET"
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$TARGET/yt-dlp"
chmod +x "$TARGET/yt-dlp"

# 2. Tải ffmpeg (.tar.gz)
mkdir -p "$TARGET/ffmpeg"
curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.gz -o ffmpeg.tar.gz
tar -xzf ffmpeg.tar.gz

# 3. Lấy folder đã giải nén
FOLDER=$(find . -maxdepth 1 -type d -name "ffmpeg-*-static" | head -n 1)

# Kiểm tra nếu không tìm thấy file ffmpeg
if [ ! -f "$FOLDER/ffmpeg" ]; then
  echo "❌ Không tìm thấy file ffmpeg trong $FOLDER"
  exit 1
fi

# 4. Copy và cấp quyền chạy
cp "$FOLDER/ffmpeg" "$TARGET/ffmpeg/ffmpeg"
chmod +x "$TARGET/ffmpeg/ffmpeg"

echo "✅ Đã tải và cấu hình xong yt-dlp + ffmpeg"
