#!/bin/bash

echo "👉 Đang tải yt-dlp và ffmpeg (Linux)..."

TARGET="src/main/resources/bin"

# Tải yt-dlp
mkdir -p "$TARGET"
curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$TARGET/yt-dlp"
chmod +x "$TARGET/yt-dlp"

# Tải ffmpeg
mkdir -p "$TARGET/ffmpeg"
curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -o ffmpeg.tar.xz
tar -xf ffmpeg.tar.xz

FOLDER=$(find . -type d -name "ffmpeg-*-static" | head -n 1)
cp "$FOLDER/ffmpeg" "$TARGET/ffmpeg/ffmpeg"
chmod +x "$TARGET/ffmpeg/ffmpeg"

echo "✅ Hoàn tất."
