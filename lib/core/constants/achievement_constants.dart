class AchievementDefinition {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int xpReward;
  final String tier; // bronze, silver, gold, platinum

  const AchievementDefinition({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.xpReward,
    required this.tier,
  });
}

const List<AchievementDefinition> achievementPool = [
  // Progression
  AchievementDefinition(id: 'achv_first_blood', title: 'First Blood', description: 'Tangkap Morphanimal pertamamu.', icon: '🐾', xpReward: 50, tier: 'bronze'),
  AchievementDefinition(id: 'achv_hunter_5', title: 'Novice Hunter', description: 'Tangkap 5 Morphanimal.', icon: '🎖️', xpReward: 100, tier: 'bronze'),
  AchievementDefinition(id: 'achv_hunter_20', title: 'Adept Hunter', description: 'Tangkap 20 Morphanimal.', icon: '🏅', xpReward: 250, tier: 'silver'),
  AchievementDefinition(id: 'achv_hunter_50', title: 'Master Hunter', description: 'Tangkap 50 Morphanimal.', icon: '🏆', xpReward: 500, tier: 'gold'),
  
  // Rarity
  AchievementDefinition(id: 'achv_rare_1', title: 'Lucky Find', description: 'Dapatkan 1 kreatur Rare.', icon: '✨', xpReward: 100, tier: 'bronze'),
  AchievementDefinition(id: 'achv_epic_1', title: 'Epic Encounter', description: 'Dapatkan 1 kreatur Epic.', icon: '🌟', xpReward: 200, tier: 'silver'),
  AchievementDefinition(id: 'achv_legendary_1', title: 'Mythical Beast', description: 'Dapatkan 1 kreatur Legendary.', icon: '👑', xpReward: 500, tier: 'gold'),
  
  // Element
  AchievementDefinition(id: 'achv_fire_master', title: 'Fire Master', description: 'Kumpulkan 10 kreatur elemen Fire.', icon: '🔥', xpReward: 300, tier: 'silver'),
  AchievementDefinition(id: 'achv_water_master', title: 'Water Master', description: 'Kumpulkan 10 kreatur elemen Water.', icon: '💧', xpReward: 300, tier: 'silver'),
  
  // Gameplay / Streak
  AchievementDefinition(id: 'achv_streak_3', title: 'Consistent', description: 'Login 3 hari berturut-turut.', icon: '📅', xpReward: 150, tier: 'bronze'),
  AchievementDefinition(id: 'achv_streak_7', title: 'Dedicated', description: 'Login 7 hari berturut-turut.', icon: '🔥', xpReward: 350, tier: 'silver'),
];
