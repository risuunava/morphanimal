import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/player.dart';

part 'player_model.g.dart';

@HiveType(typeId: 1)
class PlayerModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String name;
  @HiveField(2) late int level;
  @HiveField(3) late int xp;
  @HiveField(4) late int gold;
  @HiveField(5) late int streak;
  @HiveField(6) late DateTime lastLogin;
  @HiveField(7) late List<String> achievements;
  @HiveField(8) late List<String> battleTeamIds;

  /// Convert HiveModel → Domain Entity
  Player toEntity() {
    return Player(
      id: id,
      name: name,
      level: level,
      xp: xp,
      gold: gold,
      streak: streak,
      lastLogin: lastLogin,
      achievements: List<String>.from(achievements),
      battleTeamIds: List<String>.from(battleTeamIds),
    );
  }

  /// Convert Domain Entity → HiveModel
  static PlayerModel fromEntity(Player entity) {
    final model = PlayerModel();
    model.id = entity.id;
    model.name = entity.name;
    model.level = entity.level;
    model.xp = entity.xp;
    model.gold = entity.gold;
    model.streak = entity.streak;
    model.lastLogin = entity.lastLogin;
    model.achievements = List<String>.from(entity.achievements);
    model.battleTeamIds = List<String>.from(entity.battleTeamIds);
    return model;
  }
}
