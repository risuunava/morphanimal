import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class AppPermissionHandler {
  /// Minta permission kamera.
  /// Return true jika granted, false jika denied.
  static Future<bool> requestCamera(BuildContext context) async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      if (context.mounted) await _showSettingsDialog(context, 'Kamera');
      return false;
    }
    final result = await Permission.camera.request();
    if (result.isDenied && context.mounted) {
      await _showDeniedDialog(context, 'Kamera');
    }
    return result.isGranted;
  }

  /// Minta permission storage (baca/tulis).
  static Future<bool> requestStorage(BuildContext context) async {
    // Android 13+ pakai READ_MEDIA_IMAGES, versi lama pakai STORAGE
    Permission perm = Permission.photos;
    if (!await perm.status.isGranted) {
      perm = Permission.storage;
    }
    final status = await perm.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      if (context.mounted) await _showSettingsDialog(context, 'Penyimpanan');
      return false;
    }
    final result = await perm.request();
    return result.isGranted;
  }

  static Future<void> _showDeniedDialog(BuildContext context, String name) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Izin $name Diperlukan'),
        content: Text(
          'Morphanimal memerlukan akses $name untuk menangkap kreatur. '
          'Silakan izinkan di dialog berikutnya.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  static Future<void> _showSettingsDialog(BuildContext context, String name) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Izin $name Diblokir'),
        content: Text(
          'Izin $name telah diblokir secara permanen. '
          'Buka Pengaturan untuk mengaktifkannya kembali.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Buka Pengaturan'),
          ),
        ],
      ),
    );
  }
}
