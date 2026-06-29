import '../../domain/entities/creature.dart';

abstract class CreatureRepository {
  Future<void> save(Creature creature);
  Future<Creature?> findById(String id);
  Future<List<Creature>> getAll({String? filterElement, String? filterRarity});
  Future<void> update(Creature creature);
  Future<void> delete(String id);
}
