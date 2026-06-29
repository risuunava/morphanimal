import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/skill.dart';

part 'skill_model.g.dart';

@HiveType(typeId: 2)
class SkillModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String name;
  @HiveField(2) late String element;
  @HiveField(3) late int power;
  @HiveField(4) late int accuracy;
  @HiveField(5) late int ppMax;
  @HiveField(6) String? statusEffect;

  /// Convert HiveModel → Domain Entity
  Skill toEntity() {
    return Skill(
      id: id,
      name: name,
      element: element,
      power: power,
      accuracy: accuracy,
      ppMax: ppMax,
      statusEffect: statusEffect,
    );
  }

  /// Convert Domain Entity → HiveModel
  static SkillModel fromEntity(Skill entity) {
    final model = SkillModel();
    model.id = entity.id;
    model.name = entity.name;
    model.element = entity.element;
    model.power = entity.power;
    model.accuracy = entity.accuracy;
    model.ppMax = entity.ppMax;
    model.statusEffect = entity.statusEffect;
    return model;
  }
}
