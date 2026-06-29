import '../../core/constants/element_constants.dart';
import '../../core/utils/seed_generator.dart';

class ElementResolver {
  static String resolve(String animalGroup, DateTime captureTime, String seed) {
    final mapping = animalElementMap[animalGroup] ?? animalElementMap['unknown']!;
    final hour = captureTime.hour;

    // Time modifier (sesuai GDD 3.4)
    bool isNight = hour >= 20 || hour < 5;
    bool isGoldenHour = (hour >= 6 && hour < 8) || (hour >= 17 && hour < 19);

    // Jika ada time modifier kuat, ada 30% chance override
    if (isNight && SeedGenerator.seededDouble(seed, 'night') < 0.30) {
      return 'shadow';
    }
    if (isGoldenHour && SeedGenerator.seededDouble(seed, 'golden') < 0.30) {
      return 'light';
    }

    // 70% primary, 30% secondary
    if (mapping.primary != null && SeedGenerator.seededDouble(seed, 'elem') < 0.70) {
      return mapping.primary!;
    }

    // Pilih dari secondary secara random
    final idx = SeedGenerator.seededInt(seed, 'elem2', 0, mapping.secondary.length);
    return mapping.secondary[idx];
  }
}
