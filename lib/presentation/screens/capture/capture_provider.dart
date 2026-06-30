import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/creature.dart';
import '../../../domain/entities/player.dart';
import '../../../game/creature_generator.dart';
import '../../../core/utils/image_utils.dart';
import '../../../ai/preprocessing.dart';
import '../../../ai/species_classifier.dart';
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
      // 1. Blur check
      final isBlurry = await ImagePreprocessor.isBlurry(imageFile);
      if (isBlurry) {
        state = CaptureStateFailed(reason: CaptureFailReason.blurry);
        return;
      }

      // 2. Preprocess image untuk model (quantized uint8)
      final preprocessed = await ImagePreprocessor.prepareForModelQuantized(imageFile);

      // 3. Stage 1: cek apakah ada hewan
      final detector = _ref.read(animalDetectorProvider);
      await detector.initialize();
      final isAnimal = await detector.isAnimal(preprocessed);
      if (!isAnimal) {
        state = CaptureStateFailed(reason: CaptureFailReason.notAnimal);
        return;
      }

      // 4. Stage 2: klasifikasi spesies
      final classifier = _ref.read(speciesClassifierProvider);
      await classifier.initialize();
      final results = await classifier.classify(preprocessed);
      final top = classifier.pickResult(results);

      DetectionResult detection;
      if (top == null && results.isNotEmpty) {
        // Ambiguous — minta user pilih
        state = CaptureStateAmbiguous(options: results.take(3).toList());
        return;
      } else if (top == null) {
        detection = DetectionResult.unknown();
      } else {
        detection = top;
      }

      // 5. Get player
      final imageBytes = await imageFile.readAsBytes();
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

      // 6. Generate creature
      final creature = CreatureGenerator.generate(
        detection: detection,
        imageBytes: imageBytes,
        userId: player.id,
        player: player,
      );

      // 7. Save images
      final paths = await ImageUtils.saveCreatureImages(imageFile, creature.id);
      final creatureWithPaths = creature.copyWith(
        imagePath: paths.thumbnail,
        rawImagePath: paths.original,
      );

      // 8. Save to Hive
      await _ref.read(creatureRepositoryProvider).save(creatureWithPaths);

      // 9. Update bestiary
      await _ref
          .read(hiveDatasourceProvider)
          .markSpeciesDiscovered(creatureWithPaths.species);

      // 10. Invalidate collection cache
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
