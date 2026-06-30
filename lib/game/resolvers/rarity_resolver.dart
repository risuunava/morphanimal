import 'dart:math';
import '../../core/utils/seed_generator.dart';

class RarityResolver {
  static String resolve(String seed, int streakDays, {bool isUnknown = false}) {
    final roll = SeedGenerator.seededDouble(seed, 'rarity');
    final bonus = min(streakDays * 0.01, 0.05);
    // Unknown Beast mendapat rarity boost +10% sesuai GDD Task 2.6
    final unknownBonus = isUnknown ? 0.10 : 0.0;
    final finalRoll = roll + bonus + unknownBonus;

    if (finalRoll < 0.55) return 'common';
    if (finalRoll < 0.80) return 'rare';
    if (finalRoll < 0.95) return 'epic';
    return 'legendary';
  }
}
