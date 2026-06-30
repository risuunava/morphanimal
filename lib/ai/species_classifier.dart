import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class DetectionResult {
  final String species;       // "Felis catus" atau class dari model
  final String commonName;    // "Kucing Domestik"
  final String animalGroup;   // "cat", "dog", "bird", etc.
  final double confidence;
  
  DetectionResult({
    required this.species,
    required this.commonName,
    required this.animalGroup,
    required this.confidence,
  });

  factory DetectionResult.unknown() {
    return DetectionResult(
      species: 'unknown',
      commonName: 'Unknown Beast',
      animalGroup: 'unknown',
      confidence: 1.0,
    );
  }
}

class AnimalInfo {
  final String group;
  final String commonName;
  const AnimalInfo({required this.group, required this.commonName});
}

class SpeciesClassifier {
  late Interpreter _interpreter;
  late List<String> _labels;

  // Map dari label yang umum dari model ImageNet ke animal group
  // Karena model kita adalah generic MobileNet ImageNet
  static const Map<String, AnimalInfo> speciesDatabase = {
    // Kucing
    'tabby, tabby cat': AnimalInfo(group: 'cat', commonName: 'Kucing Peliharaan'),
    'tiger cat': AnimalInfo(group: 'cat', commonName: 'Kucing Loreng'),
    'Persian cat': AnimalInfo(group: 'cat', commonName: 'Kucing Persia'),
    'Siamese cat, Siamese': AnimalInfo(group: 'cat', commonName: 'Kucing Siam'),
    'Egyptian cat': AnimalInfo(group: 'cat', commonName: 'Kucing Mesir'),
    'cougar, puma, catamount, mountain lion, painter, panther, Felis concolor': AnimalInfo(group: 'cat', commonName: 'Puma / Panther'),
    'tiger, Panthera tigris': AnimalInfo(group: 'cat', commonName: 'Harimau'),
    'lion, king of beasts, Panthera leo': AnimalInfo(group: 'cat', commonName: 'Singa'),
    'leopard, Panthera pardus': AnimalInfo(group: 'cat', commonName: 'Macan Tutul'),
    'snow leopard, ounce, Panthera uncia': AnimalInfo(group: 'cat', commonName: 'Macan Tutul Salju'),
    
    // Anjing / Canid
    'golden retriever': AnimalInfo(group: 'dog', commonName: 'Anjing Golden Retriever'),
    'Labrador retriever': AnimalInfo(group: 'dog', commonName: 'Anjing Labrador'),
    'German shepherd, German shepherd dog, German police dog, alsatian': AnimalInfo(group: 'dog', commonName: 'Anjing Gembala Jerman'),
    'Chihuahua': AnimalInfo(group: 'dog', commonName: 'Anjing Chihuahua'),
    'husky': AnimalInfo(group: 'dog', commonName: 'Anjing Husky'),
    'pug, pug-dog': AnimalInfo(group: 'dog', commonName: 'Anjing Pug'),
    'red fox, Vulpes vulpes': AnimalInfo(group: 'dog', commonName: 'Rubah Merah'),
    'coyote, prairie wolf, brush wolf, Canis latrans': AnimalInfo(group: 'dog', commonName: 'Koyote'),
    'timber wolf, grey wolf, gray wolf, Canis lupus': AnimalInfo(group: 'dog', commonName: 'Serigala'),

    // Burung
    'macaw': AnimalInfo(group: 'bird', commonName: 'Burung Macaw'),
    'bald eagle, American eagle, Haliaeetus leucocephalus': AnimalInfo(group: 'bird', commonName: 'Elang Botak'),
    'ostrich, Struthio camelus': AnimalInfo(group: 'bird', commonName: 'Burung Unta'),
    'peacock': AnimalInfo(group: 'bird', commonName: 'Burung Merak'),
    'flamingo': AnimalInfo(group: 'bird', commonName: 'Burung Flamingo'),
    'pelican': AnimalInfo(group: 'bird', commonName: 'Burung Pelikan'),

    // Reptil / Amfibi
    'green lizard, Lacerta viridis': AnimalInfo(group: 'reptile', commonName: 'Kadal Hijau'),
    'agama': AnimalInfo(group: 'reptile', commonName: 'Kadal Agama'),
    'iguana, iguana iguana': AnimalInfo(group: 'reptile', commonName: 'Iguana'),
    'American alligator, Alligator mississipiensis': AnimalInfo(group: 'reptile', commonName: 'Aligator Amerika'),
    'tree frog, tree-frog': AnimalInfo(group: 'amphibian', commonName: 'Katak Pohon'),
    'bullfrog, Rana catesbeiana': AnimalInfo(group: 'amphibian', commonName: 'Katak Banteng'),
    'sea snake': AnimalInfo(group: 'reptile', commonName: 'Ular Laut'),
    
    // Ikan / Air
    'goldfish, Carassius auratus': AnimalInfo(group: 'fish', commonName: 'Ikan Mas Koki'),
    'great white shark, white shark, man-eater, man-eating shark, Carcharodon carcharias': AnimalInfo(group: 'fish', commonName: 'Hiu Putih Besar'),
    'stingray': AnimalInfo(group: 'fish', commonName: 'Ikan Pari'),

    // Serangga / Laba-laba
    'tarantula': AnimalInfo(group: 'insect', commonName: 'Tarantula'),
    'scorpion': AnimalInfo(group: 'insect', commonName: 'Kalajengking'),
    'monarch, monarch butterfly, milkweed butterfly, Danaus plexippus': AnimalInfo(group: 'insect', commonName: 'Kupu-kupu Monarch'),
    'bee': AnimalInfo(group: 'insect', commonName: 'Lebah'),
    
    // Lainnya (Primate, dll)
    'chimpanzee, chimp, Pan troglodytes': AnimalInfo(group: 'primate', commonName: 'Simpanse'),
    'gorilla, Gorilla gorilla': AnimalInfo(group: 'primate', commonName: 'Gorila'),
    'macaque': AnimalInfo(group: 'primate', commonName: 'Monyet Makaka'),
    'brown bear, bruin, Ursus arctos': AnimalInfo(group: 'unknown', commonName: 'Beruang Cokelat'),
    'panda, giant panda, panda bear, coon bear, Ailuropoda melanoleuca': AnimalInfo(group: 'unknown', commonName: 'Panda'),
  };

  Future<void> initialize() async {
    _interpreter = await Interpreter.fromAsset('assets/models/animal_classifier.tflite');
    final labelData = await rootBundle.loadString('assets/models/animal_labels.txt');
    _labels = labelData.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  Future<List<DetectionResult>> classify(Uint8List preprocessedInput) async {
    var input = preprocessedInput.reshape([1, 224, 224, 3]);
    var output = List<int>.filled(1 * 1001, 0).reshape([1, 1001]);

    _interpreter.run(input, output);
    
    List<int> result = output[0];
    
    // Simpan semua score dengan indexnya
    List<MapEntry<int, int>> scoreList = [];
    for (int i = 0; i < result.length; i++) {
      scoreList.add(MapEntry(i, result[i]));
    }
    
    // Sort dari terbesar ke terkecil
    scoreList.sort((a, b) => b.value.compareTo(a.value));
    
    // Ambil top 5
    List<DetectionResult> detections = [];
    
    for (int i = 0; i < 5; i++) {
      if (i >= scoreList.length) break;
      
      int index = scoreList[i].key;
      double confidence = scoreList[i].value / 255.0;
      
      if (confidence >= 0.15) { // Threshold toleran
        String label = _labels.length > index ? _labels[index] : "unknown";
        
        // Cari di map
        AnimalInfo info = speciesDatabase[label] ?? _heuristicMap(label);
        
        detections.add(DetectionResult(
          species: label,
          commonName: info.commonName,
          animalGroup: info.group,
          confidence: confidence,
        ));
      }
    }
    
    return detections;
  }
  
  AnimalInfo _heuristicMap(String label) {
    String lowerLabel = label.toLowerCase();
    
    if (lowerLabel.contains('cat') || lowerLabel.contains('lion') || lowerLabel.contains('tiger')) {
      return AnimalInfo(group: 'cat', commonName: _formatLabel(label));
    }
    if (lowerLabel.contains('dog') || lowerLabel.contains('hound') || lowerLabel.contains('wolf') || lowerLabel.contains('fox')) {
       return AnimalInfo(group: 'dog', commonName: _formatLabel(label));
    }
    if (lowerLabel.contains('bird') || lowerLabel.contains('eagle') || lowerLabel.contains('owl') || lowerLabel.contains('duck')) {
       return AnimalInfo(group: 'bird', commonName: _formatLabel(label));
    }
    if (lowerLabel.contains('fish') || lowerLabel.contains('shark')) {
       return AnimalInfo(group: 'fish', commonName: _formatLabel(label));
    }
    if (lowerLabel.contains('snake') || lowerLabel.contains('lizard') || lowerLabel.contains('turtle')) {
       return AnimalInfo(group: 'reptile', commonName: _formatLabel(label));
    }
    if (lowerLabel.contains('frog') || lowerLabel.contains('toad')) {
       return AnimalInfo(group: 'amphibian', commonName: _formatLabel(label));
    }
    if (lowerLabel.contains('spider') || lowerLabel.contains('ant') || lowerLabel.contains('bee') || lowerLabel.contains('butterfly')) {
       return AnimalInfo(group: 'insect', commonName: _formatLabel(label));
    }
    if (lowerLabel.contains('monkey') || lowerLabel.contains('ape') || lowerLabel.contains('macaque') || lowerLabel.contains('chimp')) {
       return AnimalInfo(group: 'primate', commonName: _formatLabel(label));
    }
    
    return AnimalInfo(group: 'unknown', commonName: _formatLabel(label));
  }
  
  String _formatLabel(String label) {
     List<String> parts = label.split(',');
     String firstPart = parts[0];
     if (firstPart.length > 1) {
       return firstPart[0].toUpperCase() + firstPart.substring(1);
     }
     return firstPart;
  }

  // Decision logic sesuai GDD:
  DetectionResult? pickResult(List<DetectionResult> results) {
    if (results.isEmpty) return null;
    final top = results.first;
    if (top.confidence >= 0.65) return top;  // Auto-pick
    if (top.confidence >= 0.40) return null;  // Minta user pilih (return null = ambiguous)
    return DetectionResult.unknown();          // Unknown Beast
  }
  
  void dispose() {
    _interpreter.close();
  }
}
