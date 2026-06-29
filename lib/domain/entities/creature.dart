/// Pure Dart entity — tidak ada import Flutter/Hive di layer ini
class Creature {
  final String id;
  final String species;         // "Felis catus"
  final String commonName;      // "Kucing Domestik"
  final String creatureName;    // "Umbren Claw"
  final String element;         // "shadow"
  final String rarity;          // "epic"
  final int level;
  final int xp;
  final int hp;
  final int atk;
  final int def;
  final int spd;
  final Map<String, int> ivs;   // {"hp": 24, "atk": 18, ...}
  final List<String> skillIds;
  final String imagePath;       // path thumbnail
  final String rawImagePath;    // path foto asli
  final String seed;
  final DateTime capturedAt;
  final String? locationTag;
  final bool isFavorite;

  const Creature({
    required this.id,
    required this.species,
    required this.commonName,
    required this.creatureName,
    required this.element,
    required this.rarity,
    required this.level,
    required this.xp,
    required this.hp,
    required this.atk,
    required this.def,
    required this.spd,
    required this.ivs,
    required this.skillIds,
    required this.imagePath,
    required this.rawImagePath,
    required this.seed,
    required this.capturedAt,
    this.locationTag,
    required this.isFavorite,
  });

  Creature copyWith({
    String? id,
    String? species,
    String? commonName,
    String? creatureName,
    String? element,
    String? rarity,
    int? level,
    int? xp,
    int? hp,
    int? atk,
    int? def,
    int? spd,
    Map<String, int>? ivs,
    List<String>? skillIds,
    String? imagePath,
    String? rawImagePath,
    String? seed,
    DateTime? capturedAt,
    String? locationTag,
    bool? isFavorite,
  }) {
    return Creature(
      id: id ?? this.id,
      species: species ?? this.species,
      commonName: commonName ?? this.commonName,
      creatureName: creatureName ?? this.creatureName,
      element: element ?? this.element,
      rarity: rarity ?? this.rarity,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      hp: hp ?? this.hp,
      atk: atk ?? this.atk,
      def: def ?? this.def,
      spd: spd ?? this.spd,
      ivs: ivs ?? this.ivs,
      skillIds: skillIds ?? this.skillIds,
      imagePath: imagePath ?? this.imagePath,
      rawImagePath: rawImagePath ?? this.rawImagePath,
      seed: seed ?? this.seed,
      capturedAt: capturedAt ?? this.capturedAt,
      locationTag: locationTag ?? this.locationTag,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() =>
      'Creature(id: $id, creatureName: $creatureName, element: $element, rarity: $rarity, level: $level)';
}
