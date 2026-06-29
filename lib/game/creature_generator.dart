import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import '../domain/entities/creature.dart';
import '../domain/entities/player.dart';
import 'resolvers/element_resolver.dart';
import 'resolvers/rarity_resolver.dart';
import 'resolvers/stat_calculator.dart';
import 'resolvers/name_generator.dart';
import 'resolvers/skill_assigner.dart';
import '../core/utils/seed_generator.dart';

/// Hasil deteksi dari AI pipeline
class DetectionResult {
  final String species;       // "Felis catus"
  final String commonName;    // "Kucing Domestik"
  final String animalGroup;   // "cat", "dog", "bird", etc.
  final double confidence;

  const DetectionResult({
    required this.species,
    required this.commonName,
    required this.animalGroup,
    required this.confidence,
  });

  /// Fallback untuk hewan tidak dikenal
  factory DetectionResult.unknown() => const DetectionResult(
    species: 'Unknown',
    commonName: 'Unknown Beast',
    animalGroup: 'unknown',
    confidence: 0.0,
  );
}

/// Orchestrator utama: gabungkan semua resolver menjadi satu Creature
class CreatureGenerator {
  static Creature generate({
    required DetectionResult detection,
    required Uint8List imageBytes,
    required String userId,
    required Player player,
  }) {
    final captureTime = DateTime.now();
    final seed = SeedGenerator.generate(
      imageBytes: imageBytes,
      userId: userId,
      captureTime: captureTime,
    );

    final element = ElementResolver.resolve(detection.animalGroup, captureTime, seed);
    final rarity  = RarityResolver.resolve(seed, player.streak);
    final stats   = StatCalculator.calculate(rarity, detection.animalGroup, seed);
    final name    = NameGenerator.generate(element, detection.animalGroup, rarity, seed);
    final skills  = SkillAssigner.assign(element, detection.animalGroup, rarity, seed);

    return Creature(
      id:           const Uuid().v4(),
      species:      detection.species,
      commonName:   detection.commonName,
      creatureName: name,
      element:      element,
      rarity:       rarity,
      level:        1,
      xp:           0,
      hp:           stats.hp,
      atk:          stats.atk,
      def:          stats.def,
      spd:          stats.spd,
      ivs:          stats.ivs,
      skillIds:     skills,
      imagePath:    '',         // diisi setelah save gambar
      rawImagePath: '',
      seed:         seed,
      capturedAt:   captureTime,
      isFavorite:   false,
    );
  }
}
