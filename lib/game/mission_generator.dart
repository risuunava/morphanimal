import '../core/constants/mission_constants.dart';
import '../core/utils/seed_generator.dart';

class DailyMission {
  final String id;
  final String defId;
  final String title;
  final String description;
  final String icon;
  final int target;
  final int progress;
  final bool completed;
  final bool claimed;
  final int xpReward;
  final int goldReward;

  const DailyMission({
    required this.id,
    required this.defId,
    required this.title,
    required this.description,
    required this.icon,
    required this.target,
    required this.progress,
    required this.completed,
    required this.claimed,
    required this.xpReward,
    required this.goldReward,
  });

  DailyMission copyWith({
    int? progress,
    bool? completed,
    bool? claimed,
  }) =>
      DailyMission(
        id: id,
        defId: defId,
        title: title,
        description: description,
        icon: icon,
        target: target,
        progress: progress ?? this.progress,
        completed: completed ?? this.completed,
        claimed: claimed ?? this.claimed,
        xpReward: xpReward,
        goldReward: goldReward,
      );
}

class MissionGenerator {
  /// Generate 3 misi harian deterministik berdasarkan seed tanggal
  static List<DailyMission> generate(DateTime date) {
    final dateSeed = '${date.year}-${date.month}-${date.day}';
    const count = 3;

    final pickedDefs = <MissionDefinition>[];
    final usedIndexes = <int>{};

    for (int i = 0; i < count; i++) {
      int idx;
      int attempts = 0;
      do {
        idx = SeedGenerator.seededInt(dateSeed, 'mission_$i${attempts++}', 0, missionPool.length);
      } while (usedIndexes.contains(idx) && attempts < 20);
      usedIndexes.add(idx);
      pickedDefs.add(missionPool[idx]);
    }

    return pickedDefs.asMap().entries.map((entry) {
      final def = entry.value;
      final desc = def.description.replaceAll('{target}', '${def.targetCount}');
      return DailyMission(
        id: '${dateSeed}_${def.id}_${entry.key}',
        defId: def.id,
        title: def.title,
        description: desc,
        icon: def.icon,
        target: def.targetCount,
        progress: 0,
        completed: false,
        claimed: false,
        xpReward: def.xpReward,
        goldReward: def.goldReward,
      );
    }).toList();
  }
}
