package tdt.com.convertjava.controller;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.text.Normalizer;
import org.springframework.core.io.InputStreamResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
public class ConverterController {

  @PostMapping("/convert")
  public ResponseEntity<InputStreamResource> convertYoutubeToMp3(@RequestParam String youtubeUrl) {
    try {
      String ytDlpPath = "D:/tools/yt-dlp.exe";
      String ffmpegDir = "D:/tools/ffmpeg/bin";
      // Tạo tên file độc nhất bằng cách thêm timestamp
      String outputTemplate = "%(title)s_" + System.currentTimeMillis() + ".%(ext)s";

      // Tạo thư mục tạm thời cho quá trình convert
      Path tempDirPath = Files.createTempDirectory("convert_");
      File tempDir = tempDirPath.toFile();

      ProcessBuilder pb = new ProcessBuilder(
              ytDlpPath,
              "--no-check-certificate",
              "--force-ipv4",
              "--extract-audio",
              "--audio-format", "mp3",
              "--ffmpeg-location", ffmpegDir,
              "--user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)",
              "-f", "bestaudio",
              "-o", outputTemplate,
              youtubeUrl
      );
      // Thiết lập thư mục làm việc của process là thư mục tạm
      pb.directory(tempDir);
      pb.redirectErrorStream(true);
      Process process = pb.start();

      try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
        String line;
        while ((line = reader.readLine()) != null) {
          System.out.println("yt-dlp: " + line);
        }
      }

      int exitCode = process.waitFor();
      if (exitCode != 0) {
        deleteDirectory(tempDir);
        return ResponseEntity.status(500).body(null);
      }

      // Lấy file MP3 từ thư mục tạm thời
      File[] mp3Files = tempDir.listFiles((dir, name) -> name.endsWith(".mp3"));
      if (mp3Files == null || mp3Files.length == 0) {
        deleteDirectory(tempDir);
        return ResponseEntity.status(500).body(null);
      }
      File mp3File = mp3Files[0];
      String originalName = mp3File.getName();
      String asciiName = toAscii(originalName);

      FileInputStream fis = new FileInputStream(mp3File);
      InputStream autoDeleteStream = new FilterInputStream(fis) {
        @Override
        public void close() throws IOException {
          super.close();
          System.out.println("🔥 Đã gửi xong file, xóa: " + mp3File.getName());
          mp3File.delete();
          deleteDirectory(tempDir);
        }
      };

      InputStreamResource resource = new InputStreamResource(autoDeleteStream);

      return ResponseEntity.ok()
              .contentLength(mp3File.length())
              .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + asciiName + "\"")
              .contentType(MediaType.parseMediaType("audio/mpeg"))
              .body(resource);

    } catch (Exception e) {
      e.printStackTrace();
      return ResponseEntity.status(500).body(null);
    }
  }

  // Phương thức xóa thư mục và các file con của nó
  private void deleteDirectory(File dir) {
    if (dir.isDirectory()) {
      File[] children = dir.listFiles();
      if (children != null) {
        for (File child : children) {
          deleteDirectory(child);
        }
      }
    }
    dir.delete();
  }

  // ✅ Xoá dấu tiếng Việt + ký tự ngoài ASCII (emoji, biểu tượng lạ)
  private String toAscii(String input) {
    String normalized = Normalizer.normalize(input, Normalizer.Form.NFD);
    String noDiacritics = normalized
            .replaceAll("\\p{InCombiningDiacriticalMarks}+", "")
            .replaceAll("đ", "d")
            .replaceAll("Đ", "D");
    return noDiacritics.replaceAll("[^\\x20-\\x7E]", "_");
  }
}
