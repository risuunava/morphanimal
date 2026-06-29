import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/providers.dart';
import '../../widgets/creature_card.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  bool _isGrid = true;
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final collectionAsync = ref.watch(collectionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Collection', style: AppTextStyles.headingMedium),
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded),
            color: AppColors.onSurface,
            onPressed: () => setState(() => _isGrid = !_isGrid),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Cari nama atau spesies...',
                prefixIcon: const Icon(Icons.search, color: AppColors.onSurfaceLow),
                filled: true,
                fillColor: AppColors.surfaceDim,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: collectionAsync.when(
        data: (creatures) {
          final filtered = creatures.where((c) {
            final matchName = c.creatureName.toLowerCase().contains(_searchQuery);
            final matchSpecies = c.species.toLowerCase().contains(_searchQuery);
            return matchName || matchSpecies;
          }).toList();

          if (filtered.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.pets_rounded, size: 64, color: AppColors.surfaceDim),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty ? 'Koleksi masih kosong!' : 'Tidak ditemukan',
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.onSurfaceMed),
                  ),
                ],
              ),
            ).animate().fadeIn();
          }

          if (_isGrid) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final c = filtered[index];
                return CreatureCard(
                  creature: c,
                  compact: true,
                  onTap: () => context.push('/detail', extra: c),
                ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
              },
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final c = filtered[index];
                return CreatureCard(
                  creature: c,
                  compact: false,
                  onTap: () => context.push('/detail', extra: c),
                ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
              },
            );
          }
        },
        loading: () => _ShimmerGrid(),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

// ─── Shimmer Loading Grid ─────────────────────────────────────────────────────

class _ShimmerGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (_, i) => Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
      ).animate(onPlay: (c) => c.repeat(reverse: true))
          .shimmer(
            delay: (i * 100).ms,
            duration: 1200.ms,
            color: Colors.white.withValues(alpha: 0.25),
          ),
    );
  }
}
