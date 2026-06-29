import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../providers/providers.dart';
import '../../providers/mission_provider.dart';
import '../../widgets/creature_card.dart';
import 'mission_card.dart';
import '../../../domain/entities/player.dart';
import '../../../domain/entities/creature.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerAsync = ref.watch(playerProvider);
    final collectionAsync = ref.watch(collectionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── App Bar ───────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.surface,
            scrolledUnderElevation: 0,
            title: const Text('Morphanimal', style: AppTextStyles.headingMedium),
            actions: [
              IconButton(
                icon: const Icon(Icons.menu_book_rounded, color: AppColors.onSurface),
                onPressed: () => context.push('/home/bestiary'),
                tooltip: 'Bestiary',
              ),
              const SizedBox(width: 4),
            ],
          ),

          // ─── Content ──────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Hunter Card
                playerAsync.when(
                  data: (player) => _HunterCard(player: player)
                      .animate().fadeIn().slideY(begin: 0.1),
                  loading: () => const _SkeletonCard(height: 130),
                  error: (_, __) => const _SkeletonCard(height: 130),
                ),

                const SizedBox(height: 24),

                // Quick Actions
                _buildSectionHeader(context, 'Aksi Cepat'),
                const SizedBox(height: 12),
                _QuickActions().animate().fadeIn(delay: 100.ms),

                // Misi Harian
                _buildSectionHeader(context, 'Misi Harian'),
                const SizedBox(height: 12),
                _DailyMissionSection().animate().fadeIn(delay: 120.ms),

                const SizedBox(height: 24),

                // Koleksi Terbaru
                _buildSectionHeader(
                  context,
                  'Koleksi Terbaru',
                  onMore: () => context.go('/home/collection'),
                ),
                const SizedBox(height: 12),
                collectionAsync.when(
                  data: (creatures) => _RecentCollection(creatures: creatures.take(6).toList())
                      .animate().fadeIn(delay: 150.ms),
                  loading: () => const _SkeletonCard(height: 160),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 100), // Bottom padding for FAB
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onMore}) {
    return Row(
      children: [
        Text(title, style: AppTextStyles.headingMedium),
        const Spacer(),
        if (onMore != null)
          TextButton(
            onPressed: onMore,
            child: const Text('Lihat Semua'),
          ),
      ],
    );
  }
}

// ─── Hunter Card ──────────────────────────────────────────────────────────────

class _HunterCard extends StatelessWidget {
  final Player? player;
  const _HunterCard({required this.player});

  @override
  Widget build(BuildContext context) {
    final p = player;
    final name = p?.name ?? 'Hunter';
    final level = p?.level ?? 1;
    final xp = p?.xp ?? 0;
    final streak = p?.streak ?? 0;
    final xpTarget = level * 100;
    final xpFraction = (xp / xpTarget).clamp(0.0, 1.0);

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A1A2E).withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                child: const Center(child: Text('🧑‍💼', style: TextStyle(fontSize: 26))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.headingMedium.copyWith(color: Colors.white)),
                    Text(
                      'Level $level Hunter',
                      style: AppTextStyles.labelSmall.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ),
              // Streak
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: streak > 0
                      ? AppColors.captureOrange.withValues(alpha: 0.25)
                      : Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      '$streak',
                      style: AppTextStyles.statNumber.copyWith(
                        color: streak > 0 ? AppColors.captureOrange : Colors.white38,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // XP bar
          Row(
            children: [
              Text(
                'XP $xp / $xpTarget',
                style: AppTextStyles.labelSmall.copyWith(color: Colors.white54),
              ),
              const Spacer(),
              Text(
                '${(xpFraction * 100).toStringAsFixed(0)}%',
                style: AppTextStyles.labelSmall.copyWith(color: Colors.white38),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: xpFraction,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.captureOrange),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions ────────────────────────────────────────────────────────────

class _QuickActions extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        _ActionChip(
          icon: '📸',
          label: 'Capture',
          color: AppColors.captureOrange,
          onTap: () => context.go('/home/capture'),
        ),
        const SizedBox(width: 12),
        _ActionChip(
          icon: '📚',
          label: 'Bestiary',
          color: const Color(0xFF7B1FA2),
          onTap: () => context.push('/home/bestiary'),
        ),
        const SizedBox(width: 12),
        _ActionChip(
          icon: '⚔️',
          label: 'Battle',
          color: const Color(0xFF1565C0),
          onTap: () => context.go('/home/battle'),
        ),
      ],
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Recent Collection ────────────────────────────────────────────────────────

class _RecentCollection extends StatelessWidget {
  final List<Creature> creatures;
  const _RecentCollection({required this.creatures});

  @override
  Widget build(BuildContext context) {
    if (creatures.isEmpty) {
      return Container(
        height: 140,
        decoration: BoxDecoration(
          color: AppColors.surfaceDim,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🐾', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 8),
              Text(
                'Belum ada kreatur. Mulai foto!',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceMed),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 185,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: creatures.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 140,
            child: CreatureCard(
              creature: creatures[index],
              compact: true,
              onTap: () => context.push('/detail', extra: creatures[index]),
            ),
          );
        },
      ),
    );
  }
}

// ─── Skeleton Placeholder ─────────────────────────────────────────────────────

class _SkeletonCard extends StatelessWidget {
  final double height;
  const _SkeletonCard({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceDim,
        borderRadius: BorderRadius.circular(20),
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(
          delay: 200.ms,
          duration: 1200.ms,
          color: Colors.white.withValues(alpha: 0.3),
        );
  }
}

// ─── Daily Mission Section ────────────────────────────────────────────────────

class _DailyMissionSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missions = ref.watch(missionProvider);
    return Column(
      children: missions.map((m) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: MissionCard(mission: m),
      )).toList(),
    );
  }
}
