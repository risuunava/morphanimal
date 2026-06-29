/// Pure Dart entity — tidak ada import Flutter/Hive di layer ini
class Player {
  final String id;
  final String name;
  final int level;
  final int xp;
  final int gold;
  final int streak;
  final DateTime lastLogin;
  final List<String> achievements;
  final List<String> battleTeamIds; // max 3

  const Player({
    required this.id,
    required this.name,
    required this.level,
    required this.xp,
    required this.gold,
    required this.streak,
    required this.lastLogin,
    required this.achievements,
    required this.battleTeamIds,
  });

  Player copyWith({
    String? id,
    String? name,
    int? level,
    int? xp,
    int? gold,
    int? streak,
    DateTime? lastLogin,
    List<String>? achievements,
    List<String>? battleTeamIds,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      gold: gold ?? this.gold,
      streak: streak ?? this.streak,
      lastLogin: lastLogin ?? this.lastLogin,
      achievements: achievements ?? this.achievements,
      battleTeamIds: battleTeamIds ?? this.battleTeamIds,
    );
  }

  @override
  String toString() =>
      'Player(id: $id, name: $name, level: $level, streak: $streak)';
}
