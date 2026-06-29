import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/hive_datasource.dart';
import '../../data/repositories/creature_repository_impl.dart';
import '../../data/repositories/player_repository_impl.dart';
import '../../domain/entities/creature.dart';

// ─── DATASOURCE ──────────────────────────────────────────────────────────────

final hiveDatasourceProvider = Provider<HiveLocalDatasource>((ref) {
  return HiveLocalDatasource();
});

// ─── REPOSITORIES ─────────────────────────────────────────────────────────────

final creatureRepositoryProvider = Provider<CreatureRepositoryImpl>((ref) {
  return CreatureRepositoryImpl(ref.watch(hiveDatasourceProvider));
});

final playerRepositoryProvider = Provider<PlayerRepositoryImpl>((ref) {
  return PlayerRepositoryImpl(ref.watch(hiveDatasourceProvider));
});

// ─── COLLECTION ───────────────────────────────────────────────────────────────

final collectionProvider = FutureProvider<List<Creature>>((ref) {
  return ref.watch(creatureRepositoryProvider).getAll();
});

final playerProvider = FutureProvider((ref) {
  return ref.watch(playerRepositoryProvider).get();
});

final bestiaryProvider = FutureProvider((ref) async {
  final entries = await ref.watch(hiveDatasourceProvider).getAllBestiaryEntries();
  return entries;
});
