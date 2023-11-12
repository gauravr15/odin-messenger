import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:flutter/widgets.dart';
import 'app_properties.dart';

class AESHelper {
  static final String aesAlgorithm = "AES/CBC/PKCS5Padding";
  static final String secretKeyAlgorithm = "PBKDF2WithHmacSHA256";

  final String secret;
  final String salt;
  final int keySize;
  final int iterationCount;

  AESHelper(this.secret, this.salt, this.keySize, this.iterationCount);

  String? encrypt(String plaintext, String iv) {
    try {
      final key = _generateSecretKey();
      if (key != null) {
        final params = ParametersWithIV(
          KeyParameter(key),
          Uint8List.fromList(utf8.encode(iv)),
        );

        final cipher = CBCBlockCipher(AESFastEngine())..init(true, params);

        final encryptedBytes =
            cipher.process(Uint8List.fromList(utf8.encode(plaintext)));
        return base64Encode(encryptedBytes);
      } else {
        print("Error: Key generation failed");
        return null;
      }
    } catch (e) {
      print("Error during encryption: $e");
      return null;
    }
  }

  String? decrypt(String encryptedText, String iv) {
    try {
      final key = _generateSecretKey();
      if (key != null) {
        final params = ParametersWithIV(
          KeyParameter(key),
          Uint8List.fromList(utf8.encode(iv)),
        );

        final cipher = CBCBlockCipher(AESFastEngine())..init(false, params);

        final encryptedBytes = base64Decode(encryptedText);
        final decryptedBytes =
            cipher.process(Uint8List.fromList(encryptedBytes));
        return utf8.decode(decryptedBytes);
      } else {
        print("Error: Key generation failed");
        return null;
      }
    } catch (e) {
      print("Error during decryption: $e");
      return null;
    }
  }

  Uint8List? _generateSecretKey() {
    try {
      final keyDerivator = PBKDF2KeyDerivator(HMac(SHA256Digest(), 64))
        ..init(Pbkdf2Parameters(
            Uint8List.fromList(utf8.encode(salt)), iterationCount, keySize));

      final keyBytes =
          keyDerivator.process(Uint8List.fromList(utf8.encode(secret)));
      return Uint8List.fromList(keyBytes);
    } catch (e) {
      print("Error during key generation: $e");
      return null;
    }
  }
}

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter services are initialized

  // Initialize properties
  await AppProperties.load();

  // Example usage with properties from the AppProperties class
  final secret = AppProperties.getProperty('encryption.secretKey') ?? '';
  final salt = AppProperties.getProperty('encryption.salt') ?? '';
  final keySize =
      int.parse(AppProperties.getProperty('encryption.keySize') ?? '0');
  final iterationCount =
      int.parse(AppProperties.getProperty('encryption.iterationCount') ?? '0');
  final iv = AppProperties.getProperty('encryption.iv') ?? '';

  final aesHelper = AESHelper(secret, salt, keySize, iterationCount);
  print(
      'secret: $secret , salt: $salt , keysize: $keySize , iterator: $iterationCount, iv: $iv');
  // Example encryption and decryption
  final plaintext = 'Hello, World!';

  // Log before encryption
  print('Before Encryption: $plaintext');

  final encryptedText = aesHelper.encrypt(plaintext, iv);
  print('Encrypted Text: $encryptedText');

  final decryptedText = aesHelper.decrypt(encryptedText!, iv);

  // Log after decryption
  print('After Decryption: $decryptedText');
}
