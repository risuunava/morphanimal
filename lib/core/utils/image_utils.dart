import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageUtils {
  static const String _appDirName = 'morphanimal';

  static Future<Directory> _getAppDir() async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/$_appDirName');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  static Future<String> _getSubDir(String sub) async {
    final base = await _getAppDir();
    final dir = Directory('${base.path}/$sub');
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir.path;
  }

  /// Compress original + buat thumbnail — return kedua path
  static Future<({String original, String thumbnail})> saveCreatureImages(
    File capturedFile,
    String creatureId,
  ) async {
    final originalsPath = await _getSubDir('originals');
    final thumbsPath    = await _getSubDir('thumbnails');

    final origPath  = '$originalsPath/${creatureId}_orig.jpg';
    final thumbPath = '$thumbsPath/${creatureId}_thumb.jpg';

    // Compress original → max 1080px, quality 80
    final origResult = await FlutterImageCompress.compressAndGetFile(
      capturedFile.path,
      origPath,
      quality: 80,
      minWidth: 1080,
      minHeight: 1080,
    );
    // Thumbnail → max 300px, quality 70
    final thumbResult = await FlutterImageCompress.compressAndGetFile(
      capturedFile.path,
      thumbPath,
      quality: 70,
      minWidth: 300,
      minHeight: 300,
    );

    return (
      original:  origResult?.path ?? capturedFile.path,
      thumbnail: thumbResult?.path ?? capturedFile.path,
    );
  }

  /// Hapus original + thumbnail berdasarkan creature ID
  static Future<void> deleteCreatureImages(String creatureId) async {
    final appDir = await _getAppDir();
    final files = [
      File('${appDir.path}/originals/${creatureId}_orig.jpg'),
      File('${appDir.path}/thumbnails/${creatureId}_thumb.jpg'),
    ];
    for (final f in files) {
      if (await f.exists()) await f.delete();
    }
  }
}
