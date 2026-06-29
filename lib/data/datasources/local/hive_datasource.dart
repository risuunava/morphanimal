import 'package:hive_flutter/hive_flutter.dart';
import '../../models/creature_model.dart';
import '../../models/player_model.dart';
import '../../models/skill_model.dart';
import '../../models/bestiary_model.dart';

class HiveLocalDatasource {
  static const String creaturesBox = 'creatures';
  static const String playerBox    = 'player';
  static const String bestiaryBox  = 'bestiary';
  static const String skillsBox    = 'skills';

  /// Inisialisasi semua adapter & buka box — dipanggil dari main.dart
  static Future<void> init() async {
    Hive.registerAdapter(CreatureModelAdapter());
    Hive.registerAdapter(PlayerModelAdapter());
    Hive.registerAdapter(SkillModelAdapter());
    Hive.registerAdapter(BestiaryModelAdapter());
    await Hive.openBox<CreatureModel>(creaturesBox);
    await Hive.openBox<PlayerModel>(playerBox);
    await Hive.openBox<BestiaryModel>(bestiaryBox);
    await Hive.openBox<SkillModel>(skillsBox);
  }

  // ─── CREATURE CRUD ───────────────────────────────────────────────────────────

  Future<void> saveCreature(CreatureModel creature) async {
    final box = Hive.box<CreatureModel>(creaturesBox);
    await box.put(creature.id, creature);
  }

  Future<CreatureModel?> getCreature(String id) async {
    final box = Hive.box<CreatureModel>(creaturesBox);
    return box.get(id);
  }

  Future<List<CreatureModel>> getAllCreatures() async {
    final box = Hive.box<CreatureModel>(creaturesBox);
    return box.values.toList();
  }

  Future<void> updateCreature(CreatureModel creature) async {
    final box = Hive.box<CreatureModel>(creaturesBox);
    await box.put(creature.id, creature);
  }

  Future<void> deleteCreature(String id) async {
    final box = Hive.box<CreatureModel>(creaturesBox);
    await box.delete(id);
  }

  // ─── PLAYER ──────────────────────────────────────────────────────────────────

  Future<void> savePlayer(PlayerModel player) async {
    final box = Hive.box<PlayerModel>(playerBox);
    await box.put('player', player);
  }

  Future<PlayerModel?> getPlayer() async {
    final box = Hive.box<PlayerModel>(playerBox);
    return box.get('player');
  }

  // ─── BESTIARY ────────────────────────────────────────────────────────────────

  Future<void> markSpeciesDiscovered(String species) async {
    final box = Hive.box<BestiaryModel>(bestiaryBox);
    final existing = box.get(species);
    if (existing != null) {
      existing.captureCount++;
      await existing.save();
    } else {
      final model = BestiaryModel()
        ..species = species
        ..discovered = true
        ..captureCount = 1
        ..firstCaptured = DateTime.now();
      await box.put(species, model);
    }
  }

  Future<List<BestiaryModel>> getAllBestiaryEntries() async {
    final box = Hive.box<BestiaryModel>(bestiaryBox);
    return box.values.toList();
  }

  // ─── SKILLS ──────────────────────────────────────────────────────────────────

  Future<void> saveSkill(SkillModel skill) async {
    final box = Hive.box<SkillModel>(skillsBox);
    await box.put(skill.id, skill);
  }

  Future<List<SkillModel>> getAllSkills() async {
    final box = Hive.box<SkillModel>(skillsBox);
    return box.values.toList();
  }
}
