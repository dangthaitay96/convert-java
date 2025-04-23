#!/bin/bash

echo "👉 Bắt đầu tải yt-dlp và ffmpeg cho Linux..."

# Thư mục đích
TARGET="src/main/resources/bin"

# 1. Tải yt-dlp
mkdir -p "$TARGET"
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$TARGET/yt-dlp"
chmod +x "$TARGET/yt-dlp"

# 2. Tải ffmpeg (định dạng tar.xz)
mkdir -p "$TARGET/ffmpeg"
curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -o ffmpeg.tar.xz
tar -xf ffmpeg.tar.xz

# 3. Lấy thư mục giải nén (tên động)
FOLDER=$(find . -maxdepth 1 -type d -name "ffmpeg-*-static" | head -n 1)

# 4. Kiểm tra và copy
if [ ! -f "$FOLDER/ffmpeg" ]; then
  echo "❌ Không tìm thấy file ffmpeg trong $FOLDER"
  exit 1
fi

cp "$FOLDER/ffmpeg" "$TARGET/ffmpeg/ffmpeg"
chmod +x "$TARGET/ffmpeg/ffmpeg"

echo "✅ Tải và copy công cụ thành công!"
