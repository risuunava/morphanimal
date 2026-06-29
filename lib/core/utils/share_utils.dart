import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/entities/creature.dart';
import '../../domain/entities/player.dart';
import '../../presentation/screens/collection/share_card.dart';

class ShareUtils {
  /// Render ShareCardWidget (1080×1080) off-screen, capture, dan bagikan.
  static Future<void> shareCreatureCard({
    required BuildContext context,
    required Creature creature,
    Player? player,
  }) async {
    try {
      final controller = ScreenshotController();

      final bytes = await controller.captureFromLongWidget(
        ShareCardWidget(creature: creature, player: player),
        delay: const Duration(milliseconds: 20),
        context: context,
        constraints: const BoxConstraints(maxWidth: 1080, maxHeight: 1080),
      );

      final directory = await getTemporaryDirectory();
      final imagePath = await File(
        '${directory.path}/share_${creature.id}_${DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
      await imagePath.writeAsBytes(bytes);

      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(imagePath.path)],
        text: 'Lihat ${creature.creatureName} yang baru kutangkap di Morphanimal! 🐾 #MorphanimalCollector',
      );
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }
}
