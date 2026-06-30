class MissionDefinition {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int targetCount;
  final int xpReward;
  final int goldReward;

  const MissionDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.targetCount,
    required this.xpReward,
    required this.goldReward,
  });
}

/// Pool 6 tipe misi sesuai GDD 7.3
const List<MissionDefinition> missionPool = [
  MissionDefinition(
    id: 'capture_any',
    title: 'Pemburu Harian',
    description: 'Tangkap {target} hewan hari ini',
    icon: '📸',
    targetCount: 3,
    xpReward: 100,
    goldReward: 50,
  ),
  MissionDefinition(
    id: 'capture_rare',
    title: 'Pemburu Elit',
    description: 'Tangkap {target} kreatur Rare atau lebih',
    icon: '💎',
    targetCount: 1,
    xpReward: 200,
    goldReward: 100,
  ),
  MissionDefinition(
    id: 'capture_element',
    title: 'Master Elemen',
    description: 'Tangkap {target} kreatur dengan elemen yang sama',
    icon: '⚡',
    targetCount: 2,
    xpReward: 150,
    goldReward: 75,
  ),
  MissionDefinition(
    id: 'win_battle',
    title: 'Gladiator',
    description: 'Menangkan {target} pertarungan hari ini',
    icon: '⚔️',
    targetCount: 2,
    xpReward: 180,
    goldReward: 90,
  ),
  MissionDefinition(
    id: 'open_app',
    title: 'Rajin Login',
    description: 'Buka app selama {target} hari berturut-turut',
    icon: '🔥',
    targetCount: 1,
    xpReward: 80,
    goldReward: 30,
  ),
  MissionDefinition(
    id: 'view_collection',
    title: 'Kolektor Sejati',
    description: 'Lihat detail {target} kreatur di koleksimu',
    icon: '📚',
    targetCount: 5,
    xpReward: 60,
    goldReward: 20,
  ),
];
