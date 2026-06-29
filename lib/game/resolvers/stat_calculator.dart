import 'package:morphanimal/core/constants/rarity_constants.dart';
import 'package:morphanimal/core/utils/seed_generator.dart';

class CreatureStats {
  final int hp;
  final int atk;
  final int def;
  final int spd;
  final Map<String, int> ivs;
  final int baseHp;
  final int baseAtk;
  final int baseDef;
  final int baseSpd;

  const CreatureStats({
    required this.hp,
    required this.atk,
    required this.def,
    required this.spd,
    required this.ivs,
    required this.baseHp,
    required this.baseAtk,
    required this.baseDef,
    required this.baseSpd,
  });
}

class StatCalculator {
  static CreatureStats calculate(String rarity, String animalGroup, String seed) {
    final range = rarityStatRanges[rarity] ?? rarityStatRanges['common']!;
    final modifier = speciesModifiers[animalGroup] ?? StatModifier.zero;

    // Base stats dari seed (deterministik dalam range)
    int baseHp  = SeedGenerator.seededInt(seed, 'hp',  range.hp[0],  range.hp[1]);
    int baseAtk = SeedGenerator.seededInt(seed, 'atk', range.atk[0], range.atk[1]);
    int baseDef = SeedGenerator.seededInt(seed, 'def', range.def[0], range.def[1]);
    int baseSpd = SeedGenerator.seededInt(seed, 'spd', range.spd[0], range.spd[1]);

    // IV: 0–31 per stat (sesuai GDD 5.3)
    int ivHp  = SeedGenerator.seededInt(seed, 'iv_hp',  0, 32);
    int ivAtk = SeedGenerator.seededInt(seed, 'iv_atk', 0, 32);
    int ivDef = SeedGenerator.seededInt(seed, 'iv_def', 0, 32);
    int ivSpd = SeedGenerator.seededInt(seed, 'iv_spd', 0, 32);

    // Apply species modifier
    baseHp  = (baseHp  * (1 + modifier.hp)).round();
    baseAtk = (baseAtk * (1 + modifier.atk)).round();
    baseDef = (baseDef * (1 + modifier.def)).round();
    baseSpd = (baseSpd * (1 + modifier.spd)).round();

    // Final stat formula: floor((base*2 + iv) * level/100 + 5)
    // Level awal = 1
    return CreatureStats(
      hp:  ((baseHp  * 2 + ivHp)  * 1 / 100 + 5).floor(),
      atk: ((baseAtk * 2 + ivAtk) * 1 / 100 + 5).floor(),
      def: ((baseDef * 2 + ivDef) * 1 / 100 + 5).floor(),
      spd: ((baseSpd * 2 + ivSpd) * 1 / 100 + 5).floor(),
      ivs: {'hp': ivHp, 'atk': ivAtk, 'def': ivDef, 'spd': ivSpd},
      baseHp: baseHp,
      baseAtk: baseAtk,
      baseDef: baseDef,
      baseSpd: baseSpd,
    );
  }
}
