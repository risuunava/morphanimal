class SkillData {
  final String id;
  final String name;
  final int power;
  final int accuracy;
  final int pp;
  final String? effect;

  const SkillData({
    required this.id,
    required this.name,
    required this.power,
    required this.accuracy,
    required this.pp,
    this.effect,
  });
}

const Map<String, List<SkillData>> skillsByElement = {
  'fire': [
    SkillData(id: 'fire_1', name: 'Ember Strike',  power: 60,  accuracy: 95, pp: 10),
    SkillData(id: 'fire_2', name: 'Inferno Blast',  power: 90,  accuracy: 80, pp: 5,  effect: 'burn'),
    SkillData(id: 'fire_3', name: 'Heat Wave',      power: 70,  accuracy: 90, pp: 8),
    SkillData(id: 'fire_4', name: 'Flame Claw',     power: 50,  accuracy: 100,pp: 15),
    SkillData(id: 'fire_5', name: 'Solar Burst',    power: 120, accuracy: 70, pp: 3,  effect: 'burn'),
  ],
  'water': [
    SkillData(id: 'wat_1', name: 'Aqua Jet',       power: 60,  accuracy: 100,pp: 10),
    SkillData(id: 'wat_2', name: 'Tidal Crash',    power: 90,  accuracy: 85, pp: 5),
    SkillData(id: 'wat_3', name: 'Deep Current',   power: 70,  accuracy: 90, pp: 8),
    SkillData(id: 'wat_4', name: 'Bubble Burst',   power: 50,  accuracy: 100,pp: 15),
    SkillData(id: 'wat_5', name: 'Maelstrom',      power: 110, accuracy: 75, pp: 4),
  ],
  'shadow': [
    SkillData(id: 'shad_1', name: 'Shadow Claw',   power: 70,  accuracy: 90, pp: 8,  effect: 'paralyze'),
    SkillData(id: 'shad_2', name: 'Night Slash',   power: 60,  accuracy: 95, pp: 10),
    SkillData(id: 'shad_3', name: 'Void Pulse',    power: 80,  accuracy: 85, pp: 6),
    SkillData(id: 'shad_4', name: 'Dark Shroud',   power: 40,  accuracy: 100,pp: 15, effect: 'confuse'),
    SkillData(id: 'shad_5', name: 'Umbral Strike', power: 100, accuracy: 75, pp: 4),
  ],
  'electric': [
    SkillData(id: 'elec_1', name: 'Volt Zap',      power: 60,  accuracy: 95, pp: 10, effect: 'paralyze'),
    SkillData(id: 'elec_2', name: 'Thunder Fang',  power: 75,  accuracy: 90, pp: 8),
    SkillData(id: 'elec_3', name: 'Shock Wave',    power: 90,  accuracy: 80, pp: 5),
    SkillData(id: 'elec_4', name: 'Static Surge',  power: 50,  accuracy: 100,pp: 15),
    SkillData(id: 'elec_5', name: 'Thunderclap',   power: 120, accuracy: 65, pp: 3,  effect: 'paralyze'),
  ],
  'nature': [
    SkillData(id: 'nat_1', name: 'Vine Whip',      power: 60,  accuracy: 100,pp: 12),
    SkillData(id: 'nat_2', name: 'Leaf Storm',     power: 100, accuracy: 80, pp: 5),
    SkillData(id: 'nat_3', name: 'Thorn Strike',   power: 70,  accuracy: 95, pp: 8),
    SkillData(id: 'nat_4', name: 'Root Bind',      power: 40,  accuracy: 100,pp: 15, effect: 'paralyze'),
    SkillData(id: 'nat_5', name: 'Petal Blizzard', power: 90,  accuracy: 85, pp: 6),
  ],
  'light': [
    SkillData(id: 'lgt_1', name: 'Flash Strike',   power: 65,  accuracy: 100,pp: 10),
    SkillData(id: 'lgt_2', name: 'Radiant Burst',  power: 90,  accuracy: 80, pp: 5),
    SkillData(id: 'lgt_3', name: 'Luminary Beam',  power: 80,  accuracy: 90, pp: 7),
    SkillData(id: 'lgt_4', name: 'Solar Flare',    power: 110, accuracy: 70, pp: 4,  effect: 'burn'),
    SkillData(id: 'lgt_5', name: 'Divine Ray',     power: 50,  accuracy: 100,pp: 15),
  ],
  'wind': [
    SkillData(id: 'wnd_1', name: 'Gust Slash',     power: 60,  accuracy: 95, pp: 12),
    SkillData(id: 'wnd_2', name: 'Whirlwind',      power: 80,  accuracy: 85, pp: 7),
    SkillData(id: 'wnd_3', name: 'Cyclone Claw',   power: 70,  accuracy: 90, pp: 8),
    SkillData(id: 'wnd_4', name: 'Air Slash',      power: 100, accuracy: 75, pp: 5),
    SkillData(id: 'wnd_5', name: 'Hurricane',      power: 120, accuracy: 65, pp: 3),
  ],
  'earth': [
    SkillData(id: 'ert_1', name: 'Rock Smash',     power: 60,  accuracy: 100,pp: 10),
    SkillData(id: 'ert_2', name: 'Earthquake',     power: 100, accuracy: 85, pp: 5),
    SkillData(id: 'ert_3', name: 'Stone Edge',     power: 80,  accuracy: 80, pp: 7),
    SkillData(id: 'ert_4', name: 'Mud Bomb',       power: 55,  accuracy: 95, pp: 12, effect: 'confuse'),
    SkillData(id: 'ert_5', name: 'Landslide',      power: 110, accuracy: 70, pp: 4),
  ],
  'ice': [
    SkillData(id: 'ice_1', name: 'Ice Shard',      power: 60,  accuracy: 100,pp: 12),
    SkillData(id: 'ice_2', name: 'Blizzard',       power: 110, accuracy: 70, pp: 4),
    SkillData(id: 'ice_3', name: 'Frost Claw',     power: 70,  accuracy: 90, pp: 8),
    SkillData(id: 'ice_4', name: 'Avalanche',      power: 90,  accuracy: 80, pp: 6),
    SkillData(id: 'ice_5', name: 'Freeze Beam',    power: 80,  accuracy: 85, pp: 7,  effect: 'paralyze'),
  ],
  'poison': [
    SkillData(id: 'poi_1', name: 'Venom Sting',    power: 55,  accuracy: 100,pp: 12, effect: 'burn'),
    SkillData(id: 'poi_2', name: 'Acid Spray',     power: 70,  accuracy: 90, pp: 8),
    SkillData(id: 'poi_3', name: 'Toxic Claw',     power: 65,  accuracy: 95, pp: 10, effect: 'burn'),
    SkillData(id: 'poi_4', name: 'Corrosive Wave', power: 90,  accuracy: 80, pp: 6),
    SkillData(id: 'poi_5', name: 'Venom Surge',    power: 100, accuracy: 75, pp: 5,  effect: 'burn'),
  ],
};

/// Skill yang bersifat khas per spesies hewan
const Map<String, String> speciesSkillMap = {
  'cat':      'shad_4',  // Dark Shroud — serangan senyap kucing
  'dog':      'nat_4',   // Root Bind — menerkam & menahan
  'bird':     'wnd_3',   // Cyclone Claw — cakar terbang
  'raptor':   'fire_4',  // Flame Claw — cakar membara
  'reptile':  'poi_3',   // Toxic Claw — cakar beracun
  'fish':     'wat_4',   // Bubble Burst — gelembung mematikan
  'insect':   'poi_1',   // Venom Sting — sengatan beracun
  'amphibian':'wat_1',   // Aqua Jet — lompatan air
  'primate':  'ert_1',   // Rock Smash — pukul batu
};
