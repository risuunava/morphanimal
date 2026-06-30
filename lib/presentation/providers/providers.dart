import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/hive_datasource.dart';
import '../../data/repositories/creature_repository_impl.dart';
import '../../data/repositories/player_repository_impl.dart';
import '../../domain/entities/creature.dart';
import '../../ai/animal_detector.dart';
import '../../ai/species_classifier.dart';
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

// ─── AI / ML ──────────────────────────────────────────────────────────────────

final animalDetectorProvider = Provider<AnimalDetector>((ref) {
  final detector = AnimalDetector();
  // We initialize async later or during app startup if needed
  ref.onDispose(() => detector.dispose());
  return detector;
});

final speciesClassifierProvider = Provider<SpeciesClassifier>((ref) {
  final classifier = SpeciesClassifier();
  ref.onDispose(() => classifier.dispose());
  return classifier;
});

// State untuk proses capture:
enum CaptureStatus { idle, scanning, ambiguous, failed, success }
