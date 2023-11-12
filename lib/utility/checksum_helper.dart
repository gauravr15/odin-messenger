import 'dart:convert';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'app_properties.dart'; // Import the class that handles property fetching

class ChecksumHelper {
  static final String aesAlgorithm = 'AES';
  static final String secretKeyAlgorithm = 'PBKDF2WithHmacSHA512';

  final String secret;
  final String salt;
  final int keySize;
  final int iterationCount;

  ChecksumHelper({
    required this.secret,
    required this.salt,
    required this.keySize,
    required this.iterationCount,
  });

  String encrypt(String plaintext) {
    try {
      CipherParameters cipherParameters = _generateCipherParameters();
      CipherParameters keyParameter =
          KeyParameter((cipherParameters as KeyParameter).key);
      BlockCipher aesCipher = AESFastEngine();
      aesCipher.init(true, keyParameter);

      Uint8List plaintextBytes = Uint8List.fromList(utf8.encode(plaintext));
      Uint8List encryptedBytes = _processData(aesCipher, plaintextBytes);
      return base64.encode(encryptedBytes);
    } catch (e) {
      print('Error during encryption: $e');
      return '';
    }
  }

  String decrypt(String encryptedText) {
    try {
      CipherParameters cipherParameters = _generateCipherParameters();
      CipherParameters keyParameter =
          KeyParameter((cipherParameters as KeyParameter).key);
      BlockCipher aesCipher = AESFastEngine();
      aesCipher.init(false, keyParameter);

      Uint8List encryptedBytes = base64.decode(encryptedText);
      Uint8List decryptedBytes = _processData(aesCipher, encryptedBytes);
      return utf8.decode(decryptedBytes);
    } catch (e) {
      print('Error during decryption: $e');
      return '';
    }
  }

  Uint8List _processData(BlockCipher cipher, Uint8List data) {
    int blockSize = cipher.blockSize;
    int dataLength = data.length;
    int resultLength =
        ((dataLength + blockSize - 1) / blockSize).ceil() * blockSize;
    Uint8List result = Uint8List(resultLength);

    int pos = 0;
    while (pos < dataLength) {
      int length =
          (pos + blockSize <= dataLength) ? blockSize : dataLength - pos;
      cipher.processBlock(data, pos, result, pos);
      pos += length;
    }

    return result;
  }

  CipherParameters _generateCipherParameters() {
    try {
      KeyDerivator derivator = PBKDF2KeyDerivator(HMac(SHA512Digest(), 128));
      List<int> passwordChars = utf8.encode(secret);
      Uint8List saltBytes = Uint8List.fromList(utf8.encode(salt));

      Pbkdf2Parameters params = Pbkdf2Parameters(
        Uint8List.fromList(saltBytes),
        iterationCount,
        keySize,
      );

      derivator.init(params);

      KeyParameter keyParameter =
          KeyParameter(Uint8List.fromList(derivator.process(Uint8List(0))));

      return keyParameter;
    } catch (e) {
      print('Error during key generation: $e');
      return KeyParameter(Uint8List.fromList([]));
    }
  }
}

void main() {
  // Example usage with properties from the AppProperties class
  final secret = AppProperties.getProperty('encryption.secretKey') ?? '';
  final salt = AppProperties.getProperty('encryption.salt') ?? '';
  final keySize =
      int.parse(AppProperties.getProperty('encryption.keySize') ?? '0');
  final iterationCount =
      int.parse(AppProperties.getProperty('encryption.iterationCount') ?? '0');

  final checksumHelper = ChecksumHelper(
    secret: secret,
    salt: salt,
    keySize: keySize,
    iterationCount: iterationCount,
  );

  // Example encryption and decryption
  final plaintext = 'Hello, World!';

  // Log before encryption
  print('Before Encryption: $plaintext');

  final encryptedText = checksumHelper.encrypt(plaintext);
  print('Encrypted Text: $encryptedText');

  final decryptedText = checksumHelper.decrypt(encryptedText);
  // Log after decryption
  print('After Decryption: $decryptedText');
}
