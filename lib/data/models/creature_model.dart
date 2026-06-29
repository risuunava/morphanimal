import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/creature.dart';

part 'creature_model.g.dart';

@HiveType(typeId: 0)
class CreatureModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String species;
  @HiveField(2) late String commonName;
  @HiveField(3) late String creatureName;
  @HiveField(4) late String element;
  @HiveField(5) late String rarity;
  @HiveField(6) late int level;
  @HiveField(7) late int xp;
  @HiveField(8) late int hp;
  @HiveField(9) late int atk;
  @HiveField(10) late int def;
  @HiveField(11) late int spd;
  @HiveField(12) late Map<String, int> ivs;
  @HiveField(13) late List<String> skillIds;
  @HiveField(14) late String imagePath;
  @HiveField(15) late String rawImagePath;
  @HiveField(16) late String seed;
  @HiveField(17) late DateTime capturedAt;
  @HiveField(18) String? locationTag;
  @HiveField(19) late bool isFavorite;

  /// Convert HiveModel → Domain Entity
  Creature toEntity() {
    return Creature(
      id: id,
      species: species,
      commonName: commonName,
      creatureName: creatureName,
      element: element,
      rarity: rarity,
      level: level,
      xp: xp,
      hp: hp,
      atk: atk,
      def: def,
      spd: spd,
      ivs: Map<String, int>.from(ivs),
      skillIds: List<String>.from(skillIds),
      imagePath: imagePath,
      rawImagePath: rawImagePath,
      seed: seed,
      capturedAt: capturedAt,
      locationTag: locationTag,
      isFavorite: isFavorite,
    );
  }

  /// Convert Domain Entity → HiveModel
  static CreatureModel fromEntity(Creature entity) {
    final model = CreatureModel();
    model.id = entity.id;
    model.species = entity.species;
    model.commonName = entity.commonName;
    model.creatureName = entity.creatureName;
    model.element = entity.element;
    model.rarity = entity.rarity;
    model.level = entity.level;
    model.xp = entity.xp;
    model.hp = entity.hp;
    model.atk = entity.atk;
    model.def = entity.def;
    model.spd = entity.spd;
    model.ivs = Map<String, int>.from(entity.ivs);
    model.skillIds = List<String>.from(entity.skillIds);
    model.imagePath = entity.imagePath;
    model.rawImagePath = entity.rawImagePath;
    model.seed = entity.seed;
    model.capturedAt = entity.capturedAt;
    model.locationTag = entity.locationTag;
    model.isFavorite = entity.isFavorite;
    return model;
  }
}
