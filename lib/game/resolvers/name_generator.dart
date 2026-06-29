import '../../core/utils/seed_generator.dart';

const Map<String, List<String>> elementPrefixes = {
  'fire':     ['Embara', 'Pyrion', 'Ignar', 'Blazen', 'Ashur'],
  'water':    ['Aquon', 'Tidalis', 'Marinu', 'Deepon', 'Waven'],
  'shadow':   ['Umbren', 'Nyxar', 'Shaden', 'Voidex', 'Duskon'],
  'electric': ['Voltis', 'Zaphar', 'Strikun', 'Sparken', 'Jolton'],
  'nature':   ['Viron', 'Leafar', 'Thornex', 'Groven', 'Bloomin'],
  'light':    ['Lumis', 'Radion', 'Glowex', 'Solaen', 'Auron'],
  'wind':     ['Zephyr', 'Gustin', 'Airon', 'Galeton', 'Drafton'],
  'earth':    ['Terron', 'Rockus', 'Clayen', 'Mudix', 'Stonex'],
  'ice':      ['Glacen', 'Frostin', 'Cryox', 'Chillon', 'Blizon'],
  'poison':   ['Toxen', 'Venaris', 'Corron', 'Sporon', 'Acidex'],
};

const Map<String, List<String>> animalSuffixes = {
  'cat':      ['Claw', 'Paw', 'Fang', 'Whisker', 'Tail'],
  'dog':      ['Hound', 'Fang', 'Howl', 'Guard', 'Paw'],
  'bird':     ['Wing', 'Talon', 'Feather', 'Sky', 'Beak'],
  'raptor':   ['Talon', 'Strike', 'Crest', 'Wing', 'Fang'],
  'reptile':  ['Scale', 'Fang', 'Tail', 'Hide', 'Jaw'],
  'fish':     ['Fin', 'Scale', 'Gill', 'Tide', 'Depth'],
  'insect':   ['Sting', 'Claw', 'Carapace', 'Wing', 'Venom'],
  'amphibian':['Leap', 'Croak', 'Hide', 'Tongue', 'Slime'],
  'primate':  ['Grip', 'Howl', 'Crest', 'Strike', 'Bound'],
  'unknown':  ['Beast', 'Form', 'Phantom', 'Wraith', 'Omen'],
};

const List<String> legendaryEpithets = [
  'the Undying', 'of the Ember', 'the Ancient', 'the Silent', 'Prime',
  'the Eternal', 'the Chosen', 'the Unseen', 'of the Void', 'Ascendant',
];

class NameGenerator {
  static String generate(
    String element,
    String animalGroup,
    String rarity,
    String seed,
  ) {
    final prefixes = elementPrefixes[element] ?? elementPrefixes['shadow']!;
    final suffixes = animalSuffixes[animalGroup] ?? animalSuffixes['unknown']!;

    final prefixIdx = SeedGenerator.seededInt(seed, 'name_prefix', 0, prefixes.length);
    final suffixIdx = SeedGenerator.seededInt(seed, 'name_suffix', 0, suffixes.length);

    final base = '${prefixes[prefixIdx]} ${suffixes[suffixIdx]}';

    // Legendary: tambahkan epitet
    if (rarity == 'legendary') {
      final epIdx = SeedGenerator.seededInt(seed, 'epithet', 0, legendaryEpithets.length);
      return '$base ${legendaryEpithets[epIdx]}';
    }
    return base;
  }
}
