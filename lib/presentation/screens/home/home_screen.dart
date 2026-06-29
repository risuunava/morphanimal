import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard', style: AppTextStyles.headingMedium),
        backgroundColor: AppColors.surface,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.dashboard_customize_rounded, size: 80, color: AppColors.surfaceDim),
            const SizedBox(height: 24),
            Text(
              'Selamat Datang di Morphanimal!',
              style: AppTextStyles.headingLarge.copyWith(color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'Tekan tombol kamera di bawah untuk\nmulai menangkap hewan di sekitarmu.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceMed),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: () => context.go('/home/collection'),
              icon: const Icon(Icons.pets_rounded),
              label: const Text('Lihat Koleksi'),
            ),
          ],
        ),
      ),
    );
  }
}
