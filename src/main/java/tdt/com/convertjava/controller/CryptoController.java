package tdt.com.convertjava.controller;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/crypto")
public class CryptoController {

  private static final String SECRET_KEY = "MySuperSecretKey"; // 16 bytes for AES-128

  @PostMapping("/encrypt")
  public String encrypt(@RequestParam String password) {
    try {
      SecretKeySpec keySpec = new SecretKeySpec(SECRET_KEY.getBytes(StandardCharsets.UTF_8), "AES");
      Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
      cipher.init(Cipher.ENCRYPT_MODE, keySpec);
      byte[] encrypted = cipher.doFinal(password.getBytes(StandardCharsets.UTF_8));
      return Base64.getEncoder().encodeToString(encrypted);
    } catch (Exception e) {
      throw new RuntimeException("Encryption error", e);
    }
  }

  @PostMapping("/decrypt")
  public String decrypt(@RequestParam String encryptedPassword) {
    try {
      SecretKeySpec keySpec = new SecretKeySpec(SECRET_KEY.getBytes(StandardCharsets.UTF_8), "AES");
      Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
      cipher.init(Cipher.DECRYPT_MODE, keySpec);
      byte[] decoded = Base64.getDecoder().decode(encryptedPassword);
      byte[] decrypted = cipher.doFinal(decoded);
      return new String(decrypted, StandardCharsets.UTF_8);
    } catch (Exception e) {
      throw new RuntimeException("Decryption error", e);
    }
  }
}
