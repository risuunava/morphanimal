import 'dart:math';
import '../../core/utils/seed_generator.dart';

class RarityResolver {
  static String resolve(String seed, int streakDays) {
    final roll = SeedGenerator.seededDouble(seed, 'rarity');
    final bonus = min(streakDays * 0.01, 0.05);
    final finalRoll = roll + bonus;

    if (finalRoll < 0.55) return 'common';
    if (finalRoll < 0.80) return 'rare';
    if (finalRoll < 0.95) return 'epic';
    return 'legendary';
  }
}
