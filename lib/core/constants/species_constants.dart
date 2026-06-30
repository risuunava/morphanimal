class SpeciesEntry {
  final String species;
  final String commonName;
  final String group;

  const SpeciesEntry({
    required this.species,
    required this.commonName,
    required this.group,
  });
}

/// Master list semua spesies yang bisa ditemukan di Bestiary
const List<SpeciesEntry> allSpecies = [
  // Kucing
  SpeciesEntry(species: 'tabby, tabby cat', commonName: 'Kucing Peliharaan', group: 'cat'),
  SpeciesEntry(species: 'tiger cat', commonName: 'Kucing Loreng', group: 'cat'),
  SpeciesEntry(species: 'Persian cat', commonName: 'Kucing Persia', group: 'cat'),
  SpeciesEntry(species: 'Siamese cat, Siamese', commonName: 'Kucing Siam', group: 'cat'),
  SpeciesEntry(species: 'Egyptian cat', commonName: 'Kucing Mesir', group: 'cat'),
  SpeciesEntry(species: 'cougar, puma, catamount, mountain lion, painter, panther, Felis concolor', commonName: 'Puma / Panther', group: 'cat'),
  SpeciesEntry(species: 'tiger, Panthera tigris', commonName: 'Harimau', group: 'cat'),
  SpeciesEntry(species: 'lion, king of beasts, Panthera leo', commonName: 'Singa', group: 'cat'),
  SpeciesEntry(species: 'leopard, Panthera pardus', commonName: 'Macan Tutul', group: 'cat'),
  SpeciesEntry(species: 'snow leopard, ounce, Panthera uncia', commonName: 'Macan Tutul Salju', group: 'cat'),

  // Anjing / Canid
  SpeciesEntry(species: 'golden retriever', commonName: 'Anjing Golden Retriever', group: 'dog'),
  SpeciesEntry(species: 'Labrador retriever', commonName: 'Anjing Labrador', group: 'dog'),
  SpeciesEntry(species: 'German shepherd, German shepherd dog, German police dog, alsatian', commonName: 'Anjing Gembala Jerman', group: 'dog'),
  SpeciesEntry(species: 'Chihuahua', commonName: 'Anjing Chihuahua', group: 'dog'),
  SpeciesEntry(species: 'husky', commonName: 'Anjing Husky', group: 'dog'),
  SpeciesEntry(species: 'pug, pug-dog', commonName: 'Anjing Pug', group: 'dog'),
  SpeciesEntry(species: 'red fox, Vulpes vulpes', commonName: 'Rubah Merah', group: 'dog'),
  SpeciesEntry(species: 'coyote, prairie wolf, brush wolf, Canis latrans', commonName: 'Koyote', group: 'dog'),
  SpeciesEntry(species: 'timber wolf, grey wolf, gray wolf, Canis lupus', commonName: 'Serigala', group: 'dog'),

  // Burung
  SpeciesEntry(species: 'macaw', commonName: 'Burung Macaw', group: 'bird'),
  SpeciesEntry(species: 'bald eagle, American eagle, Haliaeetus leucocephalus', commonName: 'Elang Botak', group: 'bird'),
  SpeciesEntry(species: 'ostrich, Struthio camelus', commonName: 'Burung Unta', group: 'bird'),
  SpeciesEntry(species: 'peacock', commonName: 'Burung Merak', group: 'bird'),
  SpeciesEntry(species: 'flamingo', commonName: 'Burung Flamingo', group: 'bird'),
  SpeciesEntry(species: 'pelican', commonName: 'Burung Pelikan', group: 'bird'),

  // Reptil / Amfibi
  SpeciesEntry(species: 'green lizard, Lacerta viridis', commonName: 'Kadal Hijau', group: 'reptile'),
  SpeciesEntry(species: 'agama', commonName: 'Kadal Agama', group: 'reptile'),
  SpeciesEntry(species: 'iguana, iguana iguana', commonName: 'Iguana', group: 'reptile'),
  SpeciesEntry(species: 'American alligator, Alligator mississipiensis', commonName: 'Aligator Amerika', group: 'reptile'),
  SpeciesEntry(species: 'tree frog, tree-frog', commonName: 'Katak Pohon', group: 'amphibian'),
  SpeciesEntry(species: 'bullfrog, Rana catesbeiana', commonName: 'Katak Banteng', group: 'amphibian'),
  SpeciesEntry(species: 'sea snake', commonName: 'Ular Laut', group: 'reptile'),

  // Ikan / Air
  SpeciesEntry(species: 'goldfish, Carassius auratus', commonName: 'Ikan Mas Koki', group: 'fish'),
  SpeciesEntry(species: 'great white shark, white shark, man-eater, man-eating shark, Carcharodon carcharias', commonName: 'Hiu Putih Besar', group: 'fish'),
  SpeciesEntry(species: 'stingray', commonName: 'Ikan Pari', group: 'fish'),

  // Serangga / Laba-laba
  SpeciesEntry(species: 'tarantula', commonName: 'Tarantula', group: 'insect'),
  SpeciesEntry(species: 'scorpion', commonName: 'Kalajengking', group: 'insect'),
  SpeciesEntry(species: 'monarch, monarch butterfly, milkweed butterfly, Danaus plexippus', commonName: 'Kupu-kupu Monarch', group: 'insect'),
  SpeciesEntry(species: 'bee', commonName: 'Lebah', group: 'insect'),

  // Primate
  SpeciesEntry(species: 'chimpanzee, chimp, Pan troglodytes', commonName: 'Simpanse', group: 'primate'),
  SpeciesEntry(species: 'gorilla, Gorilla gorilla', commonName: 'Gorila', group: 'primate'),
  SpeciesEntry(species: 'macaque', commonName: 'Monyet Makaka', group: 'primate'),

  // Others
  SpeciesEntry(species: 'brown bear, bruin, Ursus arctos', commonName: 'Beruang Cokelat', group: 'unknown'),
  SpeciesEntry(species: 'panda, giant panda, panda bear, coon bear, Ailuropoda melanoleuca', commonName: 'Panda', group: 'unknown'),

  // Unknown Beast (Task 2.6)
  SpeciesEntry(species: 'unknown', commonName: 'Unknown Beast', group: 'unknown'),
];
