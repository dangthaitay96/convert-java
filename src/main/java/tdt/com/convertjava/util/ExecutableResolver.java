package tdt.com.convertjava.util;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

public class ExecutableResolver {

  public static String resolve(
      String resourcePathWin, String resourcePathLinux, String fallbackPathWin, String name)
      throws IOException {
    if (isWindows()) {
      // Dùng file sẵn trên máy (ổ D:)
      return fallbackPathWin;
    } else {
      // Extract file từ resources khi deploy
      return extractExecutable(resourcePathLinux, name).getAbsolutePath();
    }
  }

  private static File extractExecutable(String resourcePath, String prefix) throws IOException {
    InputStream input = ExecutableResolver.class.getClassLoader().getResourceAsStream(resourcePath);
    if (input == null) {
      throw new FileNotFoundException("Không tìm thấy file: " + resourcePath);
    }
    File tempFile = File.createTempFile(prefix, "");
    Files.copy(input, tempFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
    tempFile.setExecutable(true);
    return tempFile;
  }

  private static boolean isWindows() {
    return System.getProperty("os.name").toLowerCase().contains("win");
  }
}
