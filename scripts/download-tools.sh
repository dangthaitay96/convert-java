#!/bin/bash

echo "👉 Bắt đầu tải yt-dlp và ffmpeg cho Linux..."

TARGET="src/main/resources/bin"

# 1. Tải yt-dlp
mkdir -p "$TARGET"
wget -q https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O "$TARGET/yt-dlp"
chmod +x "$TARGET/yt-dlp"

# 2. Tải ffmpeg
mkdir -p "$TARGET/ffmpeg"
wget -q https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -O ffmpeg.tar.xz

if [ ! -f ffmpeg.tar.xz ]; then
  echo "❌ Không tải được ffmpeg.tar.xz"
  exit 1
fi

tar -xf ffmpeg.tar.xz

# 3. Tìm đúng thư mục giải nén
FOLDER=$(find . -maxdepth 1 -type d -name "ffmpeg-*-static" | head -n 1)

if [ ! -f "$FOLDER/ffmpeg" ]; then
  echo "❌ Không tìm thấy file ffmpeg trong $FOLDER"
  ls -lah "$FOLDER"
  exit 1
fi

# 4. Copy vào project
cp "$FOLDER/ffmpeg" "$TARGET/ffmpeg/ffmpeg"
chmod +x "$TARGET/ffmpeg/ffmpeg"

echo "✅ Tải và copy công cụ thành công!"
