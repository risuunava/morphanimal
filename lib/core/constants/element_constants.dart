class ElementMapping {
  final String? primary;
  final List<String> secondary;
  
  const ElementMapping({this.primary, required this.secondary});
}

const Map<String, ElementMapping> animalElementMap = {
  'cat':      ElementMapping(primary: 'shadow',   secondary: ['fire', 'electric']),
  'dog':      ElementMapping(primary: 'nature',   secondary: ['light', 'water']),
  'bird':     ElementMapping(primary: 'wind',     secondary: ['light', 'electric']),
  'raptor':   ElementMapping(primary: 'fire',     secondary: ['shadow', 'wind']),
  'reptile':  ElementMapping(primary: 'earth',    secondary: ['shadow', 'poison']),
  'fish':     ElementMapping(primary: 'water',    secondary: ['electric', 'ice']),
  'insect':   ElementMapping(primary: 'poison',   secondary: ['nature', 'wind']),
  'amphibian':ElementMapping(primary: 'water',    secondary: ['nature', 'earth']),
  'primate':  ElementMapping(primary: 'nature',   secondary: ['light', 'earth']),
  'unknown':  ElementMapping(primary: null,       secondary: ['fire','water','shadow','electric','nature']),
};
