import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils {
  /// Mengambil screenshot dari [ScreenshotController] dan membagikannya.
  static Future<void> shareCard(
      ScreenshotController controller, String creatureName) async {
    try {
      final bytes = await controller.capture(delay: const Duration(milliseconds: 10));
      if (bytes == null) return;

      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/share_${DateTime.now().millisecondsSinceEpoch}.png').create();
      await imagePath.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: 'Lihat $creatureName yang baru kutangkap di Morphanimal! 🐾',
      );
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }
}
