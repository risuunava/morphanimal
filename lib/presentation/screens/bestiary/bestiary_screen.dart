import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/providers.dart';

class _CategoryFilter {
  final String label;
  final String? group;
  const _CategoryFilter(this.label, this.group);
}

const _categoryFilters = [
  _CategoryFilter('Semua', null),
  _CategoryFilter('Mamalia', 'mamalia'),
  _CategoryFilter('Burung', 'bird'),
  _CategoryFilter('Reptil', 'reptile'),
  _CategoryFilter('Amfibi', 'amphibian'),
  _CategoryFilter('Ikan', 'fish'),
  _CategoryFilter('Serangga', 'insect'),
  _CategoryFilter('Misterius', 'unknown'),
];

String _groupToCategory(String group) {
  switch (group) {
    case 'cat':
    case 'dog':
    case 'primate':
      return 'mamalia';
    default:
      return group;
  }
}

class BestiaryScreen extends ConsumerStatefulWidget {
  const BestiaryScreen({super.key});

  @override
  ConsumerState<BestiaryScreen> createState() => _BestiaryScreenState();
}

class _BestiaryScreenState extends ConsumerState<BestiaryScreen> {
  String? _activeFilter;

  @override
  Widget build(BuildContext context) {
    final bestiaryAsync = ref.watch(bestiaryProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bestiary', style: AppTextStyles.headingMedium),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
      ),
      body: bestiaryAsync.when(
        data: (entries) {
          final filtered = _activeFilter == null
              ? entries
              : entries.where((e) => _groupToCategory(e.group) == _activeFilter).toList();
          final discoveredCount = entries.where((e) => e.discovered).length;
          final totalCount = entries.length;
          final progress = totalCount > 0 ? discoveredCount / totalCount : 0.0;

          return Column(
            children: [
              // Progress Bar
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                    const SizedBox(height: 12),
                    // Filter chips
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categoryFilters.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final f = _categoryFilters[index];
                          final isActive = _activeFilter == f.group;
                          return GestureDetector(
                            onTap: () => setState(() => _activeFilter = f.group),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.captureOrange
                                    : AppColors.surfaceDim,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Center(
                                child: Text(
                                  f.label,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: isActive ? Colors.white : AppColors.onSurfaceMed,
                                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

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
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final entry = filtered[index];
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
  final BestiaryEntry entry;

  const _BestiaryCell({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isDiscovered = entry.discovered;

    return GestureDetector(
      onTap: isDiscovered
          ? () {
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
              isDiscovered ? entry.commonName : '???',
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
