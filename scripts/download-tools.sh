#!/bin/bash

echo "👉 Bắt đầu tải yt-dlp và ffmpeg cho Linux..."

# Đường dẫn đích nơi code Java sẽ tìm
TARGET="src/main/resources/bin"

# 1. Tải yt-dlp
mkdir -p "$TARGET"
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$TARGET/yt-dlp"
chmod +x "$TARGET/yt-dlp"

# 2. Tải ffmpeg
mkdir -p "$TARGET/ffmpeg"
curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -o ffmpeg.tar.xz
tar -xf ffmpeg.tar.xz

# 3. Lấy đúng thư mục giải nén
FOLDER=$(find . -maxdepth 1 -type d -name "ffmpeg-*-static" | head -n 1)

# Kiểm tra nếu không tìm thấy
if [ ! -f "$FOLDER/ffmpeg" ]; then
  echo "❌ Không tìm thấy file ffmpeg trong $FOLDER"
  exit 1
fi

# 4. Copy đúng file
cp "$FOLDER/ffmpeg" "$TARGET/ffmpeg/ffmpeg"
chmod +x "$TARGET/ffmpeg/ffmpeg"

echo "✅ Tải và copy công cụ thành công!"
