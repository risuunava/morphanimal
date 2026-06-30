import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImagePreprocessor {
  // 1. Blur detection (Laplacian variance)
  static Future<bool> isBlurry(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return true; // Asumsi blur jika gagal decode

    // Mengkonversi ke grayscale
    final grayscaleImage = img.grayscale(image);
    
    // Menghitung Laplacian Variance
    double variance = _laplacianVariance(grayscaleImage);
    
    // Jika varians < 100, gambar dianggap terlalu blur
    return variance < 100.0;
  }

  static double _laplacianVariance(img.Image image) {
    int width = image.width;
    int height = image.height;
    
    // Kernel Laplacian standar
    List<List<int>> laplacianKernel = [
      [0, 1, 0],
      [1, -4, 1],
      [0, 1, 0]
    ];
    
    List<double> laplacianValues = [];
    double sum = 0.0;
    
    for (int y = 1; y < height - 1; y++) {
      for (int x = 1; x < width - 1; x++) {
        double value = 0;
        for (int j = -1; j <= 1; j++) {
          for (int i = -1; i <= 1; i++) {
            // Ambil luminance (karena sudah grayscale, r/g/b sama)
            final pixel = image.getPixel(x + i, y + j);
            int gray = pixel.r.toInt();
            value += gray * laplacianKernel[j + 1][i + 1];
          }
        }
        laplacianValues.add(value);
        sum += value;
      }
    }
    
    double mean = sum / laplacianValues.length;
    double varianceSum = 0.0;
    
    for (var val in laplacianValues) {
      varianceSum += (val - mean) * (val - mean);
    }
    
    return varianceSum / laplacianValues.length;
  }

  // 2. Resize & center crop ke 224x224
  static Future<Uint8List> prepareForModel(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception("Failed to decode image");
    }

    // Hitung ukuran untuk center crop
    int minSize = image.width < image.height ? image.width : image.height;
    int x = (image.width - minSize) ~/ 2;
    int y = (image.height - minSize) ~/ 2;

    // Crop ke bentuk persegi
    img.Image cropped = img.copyCrop(image, x: x, y: y, width: minSize, height: minSize);

    // Resize ke ukuran yang dibutuhkan model (224x224)
    img.Image resized = img.copyResize(cropped, width: 224, height: 224);

    // Normalisasi pixel untuk model
    Float32List floatBytes = Float32List(224 * 224 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < resized.height; y++) {
      for (int x = 0; x < resized.width; x++) {
        final pixel = resized.getPixel(x, y);
        
        // Asumsi format warna RGB, normalisasi ke rentang [-1, 1] atau [0, 1]
        // Model quant (seperti mobilenet) terkadang butuh Uint8List biasa (0-255)
        // Kita sesuaikan dengan input uint8 untuk model quant
        // Disini kita akan return Uint8List karena model yang didownload adalah _quant
        floatBytes[pixelIndex++] = (pixel.r - 127.5) / 127.5; // Contoh normalisasi
        floatBytes[pixelIndex++] = (pixel.g - 127.5) / 127.5;
        floatBytes[pixelIndex++] = (pixel.b - 127.5) / 127.5;
      }
    }
    
    // Kembalikan byte buffer.
    return floatBytes.buffer.asUint8List();
  }

  // Mengubah prepareForModel untuk model TFLite Quantized (Uint8)
  static Future<Uint8List> prepareForModelQuantized(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception("Failed to decode image");
    }

    // Center crop
    int minSize = image.width < image.height ? image.width : image.height;
    int x = (image.width - minSize) ~/ 2;
    int y = (image.height - minSize) ~/ 2;

    img.Image cropped = img.copyCrop(image, x: x, y: y, width: minSize, height: minSize);

    // Resize ke 224x224
    img.Image resized = img.copyResize(cropped, width: 224, height: 224);

    // Untuk model quantized, langsung extract bytes RGB (uint8)
    Uint8List inputBuffer = Uint8List(224 * 224 * 3);
    int pixelIndex = 0;
    for (int y = 0; y < resized.height; y++) {
      for (int x = 0; x < resized.width; x++) {
        final pixel = resized.getPixel(x, y);
        inputBuffer[pixelIndex++] = pixel.r.toInt();
        inputBuffer[pixelIndex++] = pixel.g.toInt();
        inputBuffer[pixelIndex++] = pixel.b.toInt();
      }
    }
    
    return inputBuffer;
  }

  // 3. Compress untuk storage
  static Future<File> compressForStorage(File imageFile, String outputPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      outputPath,
      quality: 80,
      minWidth: 1080,
    );
    
    if (result == null) {
       throw Exception("Compression failed");
    }
    
    return File(result.path);
  }

  // 4. Generate thumbnail
  static Future<File> generateThumbnail(File imageFile, String outputPath) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      outputPath,
      quality: 70,
      minWidth: 300,
      minHeight: 300,
    );
    
    if (result == null) {
       throw Exception("Thumbnail generation failed");
    }
    
    return File(result.path);
  }
}
