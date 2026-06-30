import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/providers.dart';

class BestiaryScreen extends ConsumerWidget {
  const BestiaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bestiaryAsync = ref.watch(bestiaryProvider); // asumsikan ini akan kita buat di provider

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bestiary', style: AppTextStyles.headingMedium),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
      ),
      body: bestiaryAsync.when(
        data: (entries) {
          final discoveredCount = entries.where((e) => e.discovered).length;
          final totalCount = entries.length;
          final progress = totalCount > 0 ? discoveredCount / totalCount : 0.0;

          return Column(
            children: [
              // Progress Bar
              Container(
                padding: const EdgeInsets.all(20),
                color: AppColors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Progress Koleksi', style: AppTextStyles.labelLarge),
                        Text('$discoveredCount / $totalCount Spesies', style: AppTextStyles.labelSmall.copyWith(color: AppColors.captureOrange)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: AppColors.surfaceDim,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.captureOrange),
                      ),
                    ),
                  ],
                ),
              ),

              // Grid Spesies
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: totalCount,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _BestiaryCell(entry: entry);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _BestiaryCell extends StatelessWidget {
  final dynamic entry; // Pakai dynamic sementara agar bisa dipakai sebelum provider selesai

  const _BestiaryCell({required this.entry});

  @override
  Widget build(BuildContext context) {
    final bool isDiscovered = entry.discovered;

    return GestureDetector(
      onTap: isDiscovered
          ? () {
              // TODO: Filter collection by species (bisa arahkan ke search CollectionScreen)
              context.go('/home/collection');
            }
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDiscovered ? AppColors.surfaceDim : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDiscovered
                    ? AppColors.captureOrange.withValues(alpha: 0.1)
                    : AppColors.surfaceDim,
              ),
              child: Center(
                child: Text(
                  isDiscovered ? '🐾' : '❓',
                  style: TextStyle(
                    fontSize: 24,
                    color: isDiscovered ? null : Colors.white30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isDiscovered ? entry.species : '???',
              textAlign: TextAlign.center,
              style: AppTextStyles.labelSmall.copyWith(
                color: isDiscovered ? AppColors.onSurface : AppColors.onSurfaceLow,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (isDiscovered) ...[
              const SizedBox(height: 4),
              Text(
                'Ditangkap: ${entry.captureCount}',
                style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceMed),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
