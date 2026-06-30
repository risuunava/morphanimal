import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/achievement_constants.dart';
import '../../providers/providers.dart';
import '../../providers/mission_provider.dart';
import '../../../data/repositories/backup_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerAsync = ref.watch(playerProvider);
    final collectionAsync = ref.watch(collectionProvider);
    final missions = ref.watch(missionProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── Header ──────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: AppColors.surface,
            scrolledUnderElevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                  ),
                ),
                child: playerAsync.when(
                  data: (player) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(color: AppColors.captureOrange.withValues(alpha: 0.6), width: 2),
                        ),
                        child: const Center(child: Text('🧑‍💼', style: TextStyle(fontSize: 36))),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        player?.name ?? 'Hunter',
                        style: AppTextStyles.headingLarge.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Level ${player?.level ?? 1} Hunter  •  🔥 ${player?.streak ?? 0} hari',
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white54),
                      ),
                    ],
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),

          // ─── Content ─────────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([

                // Stats Overview
                playerAsync.when(
                  data: (player) => collectionAsync.when(
                    data: (creatures) => _StatsRow(
                      level: player?.level ?? 1,
                      collectionCount: creatures.length,
                      achievementCount: player?.achievements.length ?? 0,
                      missionsCompleted: missions.where((m) => m.claimed).length,
                    ).animate().fadeIn(),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 24),

                // Achievements Section
                playerAsync.when(
                  data: (player) => _AchievementsSection(
                    unlockedIds: Set<String>.from(player?.achievements ?? []),
                  ).animate().fadeIn(delay: 100.ms),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),

                const SizedBox(height: 24),

                // Backup Section
                const _SectionHeader(title: 'Data & Backup'),
                const SizedBox(height: 12),
                _buildBackupSection(context, ref).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackupSection(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _BackupButton(
          icon: Icons.upload_rounded,
          label: 'Ekspor Koleksi',
          subtitle: 'Simpan dan bagikan backup JSON koleksimu',
          color: AppColors.captureOrange,
          onTap: () async {
            final player = await ref.read(playerRepositoryProvider).get();
            final creatures = await ref.read(creatureRepositoryProvider).getAll();
            if (context.mounted) {
              await BackupRepository.exportAndShare(
                context: context,
                player: player,
                creatures: creatures,
              );
            }
          },
        ),
        const SizedBox(height: 12),
        _BackupButton(
          icon: Icons.download_rounded,
          label: 'Impor Koleksi',
          subtitle: 'Restore koleksi dari file backup JSON',
          color: const Color(0xFF7B1FA2),
          onTap: () => _showImportDialog(context, ref),
        ),
      ],
    );
  }

  void _showImportDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Impor Koleksi', style: AppTextStyles.headingMedium),
        content: Text(
          'Import akan menambahkan kreatur dari backup ke koleksimu saat ini.\n\n'
          'Paste isi file backup JSON di bawah ini:',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceMed),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF7B1FA2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: Buka file picker untuk pilih file .json
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('File picker (Task 2.5.2) — coming soon!'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text('Pilih File'),
          ),
        ],
      ),
    );
  }
}

// ─── Stats Row ────────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int level;
  final int collectionCount;
  final int achievementCount;
  final int missionsCompleted;

  const _StatsRow({
    required this.level,
    required this.collectionCount,
    required this.achievementCount,
    required this.missionsCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(label: 'Level', value: '$level', icon: '⭐'),
        const SizedBox(width: 10),
        _StatCard(label: 'Koleksi', value: '$collectionCount', icon: '🐾'),
        const SizedBox(width: 10),
        _StatCard(label: 'Achievements', value: '$achievementCount', icon: '🏆'),
        const SizedBox(width: 10),
        _StatCard(label: 'Misi Selesai', value: '$missionsCompleted', icon: '✅'),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(value, style: AppTextStyles.statNumber.copyWith(fontSize: 18)),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceMed, fontSize: 10), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─── Achievements Section ─────────────────────────────────────────────────────

class _AchievementsSection extends StatelessWidget {
  final Set<String> unlockedIds;
  const _AchievementsSection({required this.unlockedIds});

  @override
  Widget build(BuildContext context) {
    final unlocked = achievementPool.where((a) => unlockedIds.contains(a.id)).toList();
    final locked = achievementPool.where((a) => !unlockedIds.contains(a.id)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Achievements (${unlocked.length}/${achievementPool.length})'),
        const SizedBox(height: 12),
        if (unlocked.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                'Belum ada achievement. Mulai berburu! 🐾',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceMed),
              ),
            ),
          )
        else
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: unlocked.length + (locked.isNotEmpty ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                if (index < unlocked.length) {
                  return _AchievementBadge(achv: unlocked[index], isUnlocked: true);
                }
                // Locked placeholder
                return _AchievementBadge(achv: locked.first, isUnlocked: false);
              },
            ),
          ),
      ],
    );
  }
}

class _AchievementBadge extends StatelessWidget {
  final AchievementDefinition achv;
  final bool isUnlocked;
  const _AchievementBadge({required this.achv, required this.isUnlocked});

  @override
  Widget build(BuildContext context) {
    Color tierColor;
    switch (achv.tier) {
      case 'bronze': tierColor = const Color(0xFFCD7F32); break;
      case 'silver': tierColor = const Color(0xFFC0C0C0); break;
      case 'gold': tierColor = const Color(0xFFFFD700); break;
      default: tierColor = Colors.white;
    }

    return Opacity(
      opacity: isUnlocked ? 1 : 0.35,
      child: Tooltip(
        message: isUnlocked ? achv.title : '???',
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isUnlocked ? tierColor.withValues(alpha: 0.1) : AppColors.surfaceDim,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnlocked ? tierColor.withValues(alpha: 0.5) : Colors.transparent,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isUnlocked ? achv.icon : '❓', style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 4),
              Text(
                isUnlocked ? achv.title : '???',
                style: AppTextStyles.labelSmall.copyWith(fontSize: 8, color: tierColor),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Backup Button ────────────────────────────────────────────────────────────

class _BackupButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _BackupButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.labelLarge),
                  Text(subtitle, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceMed)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceLow),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppTextStyles.headingMedium);
  }
}
