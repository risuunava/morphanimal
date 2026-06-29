import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/creature.dart';
import '../../../domain/entities/player.dart';
import '../../../game/creature_generator.dart';
import '../../../core/utils/image_utils.dart';
import '../../providers/providers.dart';

// ─── States ──────────────────────────────────────────────────────────────────

enum CaptureFailReason { blurry, notAnimal, unknown }

sealed class CaptureState {}

class CaptureStateIdle extends CaptureState {}

class CaptureStateScanning extends CaptureState {}

class CaptureStateAmbiguous extends CaptureState {
  final List<DetectionResult> options;
  CaptureStateAmbiguous({required this.options});
}

class CaptureStateFailed extends CaptureState {
  final CaptureFailReason reason;
  CaptureStateFailed({required this.reason});
}

class CaptureStateSuccess extends CaptureState {
  final Creature creature;
  CaptureStateSuccess({required this.creature});
}

// ─── Notifier ─────────────────────────────────────────────────────────────────

class CaptureNotifier extends StateNotifier<CaptureState> {
  final Ref _ref;
  CaptureNotifier(this._ref) : super(CaptureStateIdle());

  Future<void> onCapture(File imageFile) async {
    state = CaptureStateScanning();
    try {
      // 1. Baca image bytes untuk seed generation
      final imageBytes = await imageFile.readAsBytes();

      // 2. TODO (Task 1.B): blur check & AI detection
      //    Untuk sekarang skip langsung ke generation dengan mock data
      const detection = DetectionResult(
        species: 'Felis catus',
        commonName: 'Kucing Domestik',
        animalGroup: 'cat',
        confidence: 0.92,
      );

      // 3. Get player
      final player = await _ref.read(playerRepositoryProvider).get() ??
          Player(
            id: 'player_1',
            name: 'Hunter',
            level: 1,
            xp: 0,
            gold: 0,
            streak: 0,
            lastLogin: DateTime.now(),
            achievements: [],
            battleTeamIds: [],
          );

      // 4. Generate creature
      final creature = CreatureGenerator.generate(
        detection: detection,
        imageBytes: imageBytes,
        userId: player.id,
        player: player,
      );

      // 5. Save images
      final paths = await ImageUtils.saveCreatureImages(imageFile, creature.id);
      final creatureWithPaths = creature.copyWith(
        imagePath: paths.thumbnail,
        rawImagePath: paths.original,
      );

      // 6. Save to Hive
      await _ref.read(creatureRepositoryProvider).save(creatureWithPaths);

      // 7. Update bestiary
      await _ref
          .read(hiveDatasourceProvider)
          .markSpeciesDiscovered(creatureWithPaths.species);

      // 8. Invalidate collection cache
      _ref.invalidate(collectionProvider);

      state = CaptureStateSuccess(creature: creatureWithPaths);
    } catch (e) {
      state = CaptureStateFailed(reason: CaptureFailReason.unknown);
    }
  }

  Future<void> selectDetection(DetectionResult selected, File imageFile) async {
    state = CaptureStateScanning();
    await onCapture(imageFile);
  }

  void reset() => state = CaptureStateIdle();
}

final captureNotifierProvider =
    StateNotifierProvider<CaptureNotifier, CaptureState>(
  (ref) => CaptureNotifier(ref),
);
