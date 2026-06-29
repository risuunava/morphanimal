import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Deterministik seed generator berbasis SHA256.
/// Seed sama → output sama. Dipakai oleh semua resolver generator.
class SeedGenerator {
  /// Generate seed dari imageBytes + userId + captureTime.
  /// Sama foto + user + timestamp = sama seed (deterministik).
  static String generate({
    required Uint8List imageBytes,
    required String userId,
    required DateTime captureTime,
  }) {
    final input = [
      ...imageBytes.sublist(0, min(1024, imageBytes.length)),
      ...utf8.encode(userId),
      ...utf8.encode(captureTime.millisecondsSinceEpoch.toString()),
    ];
    return sha256.convert(input).toString();
  }

  /// Random double [0.0, 1.0) dari seed + salt (deterministik).
  static double seededDouble(String seed, String salt) {
    final hash = sha256.convert(utf8.encode(seed + salt)).bytes;
    final value = (hash[0] << 24 | hash[1] << 16 | hash[2] << 8 | hash[3]);
    return value / 0xFFFFFFFF;
  }

  /// Random int dalam range [min, max) dari seed + salt (deterministik).
  static int seededInt(String seed, String salt, int minVal, int maxVal) {
    final d = seededDouble(seed, salt);
    return (minVal + d * (maxVal - minVal)).floor();
  }
}
