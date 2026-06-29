import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/achievement_constants.dart';
import '../../domain/entities/player.dart';
import '../../domain/entities/creature.dart';
import '../providers/providers.dart';

class AchievementChecker {
  final Ref ref;

  AchievementChecker(this.ref);

  /// Cek achievement yang berpotensi unlock setelah aksi tertentu.
  /// Return list achievement yang baru saja di-unlock.
  Future<List<AchievementDefinition>> checkAchievements() async {
    final player = await ref.read(playerRepositoryProvider).get();
    final creatures = await ref.read(creatureRepositoryProvider).getAll();
    
    final newlyUnlocked = <AchievementDefinition>[];
    final unlockedIds = Set<String>.from(player.achievements);

    for (final achv in achievementPool) {
      if (unlockedIds.contains(achv.id)) continue;

      bool isUnlocked = _checkCondition(achv.id, player, creatures);
      if (isUnlocked) {
        newlyUnlocked.add(achv);
        unlockedIds.add(achv.id);
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      // Hitung total bonus XP
      int totalXpBonus = newlyUnlocked.fold(0, (sum, a) => sum + a.xpReward);
      
      final updatedPlayer = player.copyWith(
        achievements: unlockedIds.toList(),
        xp: player.xp + totalXpBonus,
      );
      
      // Karena kita ga punya copyWith di model awal (Oops, let's assume update manual atau save ulang)
      // Wait, kita bisa bikin extention atau update langsung
      await ref.read(playerRepositoryProvider).save(updatedPlayer);
      ref.invalidate(playerProvider); // refresh UI
    }

    return newlyUnlocked;
  }

  bool _checkCondition(String id, Player p, List<Creature> creatures) {
    switch (id) {
      case 'achv_first_blood': return creatures.isNotEmpty;
      case 'achv_hunter_5': return creatures.length >= 5;
      case 'achv_hunter_20': return creatures.length >= 20;
      case 'achv_hunter_50': return creatures.length >= 50;
      case 'achv_rare_1': return creatures.any((c) => c.rarity == 'rare');
      case 'achv_epic_1': return creatures.any((c) => c.rarity == 'epic');
      case 'achv_legendary_1': return creatures.any((c) => c.rarity == 'legendary');
      case 'achv_fire_master': return creatures.where((c) => c.element == 'fire').length >= 10;
      case 'achv_water_master': return creatures.where((c) => c.element == 'water').length >= 10;
      case 'achv_streak_3': return p.streak >= 3;
      case 'achv_streak_7': return p.streak >= 7;
      default: return false;
    }
  }
}

final achievementCheckerProvider = Provider((ref) => AchievementChecker(ref));
