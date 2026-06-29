class StatRange {
  final List<int> hp;
  final List<int> atk;
  final List<int> def;
  final List<int> spd;
  const StatRange({required this.hp, required this.atk, required this.def, required this.spd});
}

class StatModifier {
  final double hp;
  final double atk;
  final double def;
  final double spd;
  const StatModifier({required this.hp, required this.atk, required this.def, required this.spd});
  static const zero = StatModifier(hp: 0, atk: 0, def: 0, spd: 0);
}

/// Stat ranges per rarity sesuai GDD Section 5.1
const Map<String, StatRange> rarityStatRanges = {
  'common':    StatRange(hp: [80, 120],  atk: [40, 70],   def: [30, 60],   spd: [40, 80]),
  'rare':      StatRange(hp: [120, 180], atk: [70, 110],  def: [60, 100],  spd: [80, 120]),
  'epic':      StatRange(hp: [180, 260], atk: [110, 160], def: [100, 150], spd: [120, 170]),
  'legendary': StatRange(hp: [260, 350], atk: [160, 220], def: [150, 200], spd: [170, 230]),
};

/// Species stat modifier sesuai GDD 5.2
const Map<String, StatModifier> speciesModifiers = {
  'cat':      StatModifier(hp: -0.10, atk: 0.15,  def: 0,     spd: 0.10),
  'dog':      StatModifier(hp:  0.15, atk: -0.10, def: 0.10,  spd: 0),
  'bird':     StatModifier(hp: -0.10, atk: 0.05,  def: -0.10, spd: 0.20),
  'raptor':   StatModifier(hp: -0.05, atk: 0.20,  def: -0.10, spd: 0.10),
  'reptile':  StatModifier(hp:  0.10, atk: 0.05,  def: 0.15,  spd: -0.10),
  'fish':     StatModifier(hp:  0.05, atk: -0.05, def: 0.10,  spd: 0.10),
  'insect':   StatModifier(hp: -0.15, atk: 0.10,  def: -0.05, spd: 0.20),
  'amphibian':StatModifier(hp:  0.10, atk: 0,     def: 0.10,  spd: 0),
  'primate':  StatModifier(hp:  0.05, atk: 0.05,  def: 0.05,  spd: 0.05),
};
