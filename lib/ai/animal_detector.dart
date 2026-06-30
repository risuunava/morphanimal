import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class AnimalDetector {
  late Interpreter _interpreter;
  late List<String> _labels;

  Future<void> initialize() async {
    // Memuat model MobileNet V1 Quantized
    _interpreter = await Interpreter.fromAsset('assets/models/animal_classifier.tflite');
    
    // Memuat daftar label
    final labelData = await rootBundle.loadString('assets/models/animal_labels.txt');
    _labels = labelData.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  // Return true jika ada hewan terdeteksi dengan confidence >= 0.60
  Future<bool> isAnimal(Uint8List preprocessedInput) async {
    // Model yang didownload (MobileNet V1 224 Quant) mengharapkan input
    // shape: [1, 224, 224, 3] type: uint8
    var input = preprocessedInput.reshape([1, 224, 224, 3]);

    // Model mengembalikan output array [1, 1001] type: uint8 (berisi probabilitas)
    // 1001 class untuk ImageNet.
    var output = List<int>.filled(1 * 1001, 0).reshape([1, 1001]);

    // Jalankan inferensi
    _interpreter.run(input, output);

    // Dapatkan prediksi teratas
    int maxIndex = -1;
    int maxValue = -1;
    List<int> result = output[0];
    
    for (int i = 0; i < result.length; i++) {
      if (result[i] > maxValue) {
        maxValue = result[i];
        maxIndex = i;
      }
    }

    // Hitung confidence (uint8 rentang 0-255)
    double confidence = maxValue / 255.0;

    if (maxIndex != -1 && confidence >= 0.60) {
      String predictedLabel = _labels.length > maxIndex ? _labels[maxIndex] : "Unknown";
      
      // Karena kita menggunakan pretrained model generik (ImageNet 1000 class),
      // kita perlu mengecek apakah label yang terdeteksi masuk kategori "hewan".
      // ImageNet class 1 sampai 397 rata-rata adalah hewan/makhluk hidup.
      // (Bisa diperbaiki nanti dengan deteksi keyword tertentu).
      if (maxIndex >= 1 && maxIndex <= 397) {
        return true;
      }
      
      // Keyword fallback
      final animalKeywords = ['cat', 'dog', 'bird', 'fish', 'tiger', 'lion', 'bear', 'horse', 'mouse', 'fox', 'wolf', 'spider', 'snake', 'frog', 'lizard'];
      for (var kw in animalKeywords) {
        if (predictedLabel.toLowerCase().contains(kw)) {
          return true;
        }
      }
    }
    
    return false;
  }

  void dispose() {
    _interpreter.close();
  }
}
