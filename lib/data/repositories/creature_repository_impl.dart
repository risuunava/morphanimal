import '../../domain/entities/creature.dart';
import '../../domain/repositories/creature_repository.dart';
import '../datasources/local/hive_datasource.dart';
import '../models/creature_model.dart';

class CreatureRepositoryImpl implements CreatureRepository {
  final HiveLocalDatasource _datasource;

  CreatureRepositoryImpl(this._datasource);

  @override
  Future<void> save(Creature creature) async {
    final model = CreatureModel.fromEntity(creature);
    await _datasource.saveCreature(model);
  }

  @override
  Future<Creature?> findById(String id) async {
    final model = await _datasource.getCreature(id);
    return model?.toEntity();
  }

  @override
  Future<List<Creature>> getAll({String? filterElement, String? filterRarity}) async {
    final models = await _datasource.getAllCreatures();
    var entities = models.map((m) => m.toEntity()).toList();

    if (filterElement != null && filterElement.isNotEmpty) {
      entities = entities.where((c) => c.element == filterElement).toList();
    }
    if (filterRarity != null && filterRarity.isNotEmpty) {
      entities = entities.where((c) => c.rarity == filterRarity).toList();
    }

    // Default sort: newest first
    entities.sort((a, b) => b.capturedAt.compareTo(a.capturedAt));
    return entities;
  }

  @override
  Future<void> update(Creature creature) async {
    final model = CreatureModel.fromEntity(creature);
    await _datasource.updateCreature(model);
  }

  @override
  Future<void> delete(String id) async {
    await _datasource.deleteCreature(id);
  }
}
