// lib/utils/crypto.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

class CryptoUtils {
  /// Hash a phone number using SHA256
  static String hashPhoneNumber(String phoneNumber) {
    final bytes = utf8.encode(phoneNumber); // convert to bytes
    final digest = sha256.convert(bytes);   // apply SHA256
    return digest.toString();              // return hex string
  }
}
