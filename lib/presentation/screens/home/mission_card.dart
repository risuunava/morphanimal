import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../providers/mission_provider.dart';
import '../../../game/mission_generator.dart';

class MissionCard extends ConsumerWidget {
  final DailyMission mission;
  const MissionCard({super.key, required this.mission});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = (mission.progress / mission.target).clamp(0.0, 1.0);
    final isCompleted = mission.completed;
    final isClaimed = mission.claimed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isClaimed
            ? AppColors.surfaceDim
            : (isCompleted ? const Color(0xFFE8F5E9) : AppColors.surface),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCompleted && !isClaimed
              ? SemanticColors.success.withValues(alpha: 0.5)
              : AppColors.surfaceDim,
          width: isCompleted && !isClaimed ? 1.5 : 1,
        ),
        boxShadow: isCompleted && !isClaimed
            ? [BoxShadow(color: SemanticColors.success.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4))]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(mission.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: isClaimed ? AppColors.onSurfaceLow : AppColors.onSurface,
                        decoration: isClaimed ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      mission.description,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceMed),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Claim/Status button
              if (isClaimed)
                const Icon(Icons.check_circle_rounded, color: AppColors.onSurfaceLow, size: 24)
              else if (isCompleted)
                GestureDetector(
                  onTap: () {
                    ref.read(missionProvider.notifier).claimMission(mission.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('🎉 +${mission.xpReward} XP, +${mission.goldReward} Gold!'),
                        backgroundColor: SemanticColors.success,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: SemanticColors.success,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      'Klaim!',
                      style: AppTextStyles.labelSmall.copyWith(color: Colors.white),
                    ),
                  ),
                ).animate().scale(duration: 200.ms, curve: Curves.easeOutBack),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceDim,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? SemanticColors.success : AppColors.captureOrange,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${mission.progress}/${mission.target}',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceMed),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Rewards
          Row(
            children: [
              _RewardChip(icon: '✨', value: '+${mission.xpReward} XP'),
              const SizedBox(width: 8),
              _RewardChip(icon: '💰', value: '+${mission.goldReward} Gold'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  final String icon;
  final String value;
  const _RewardChip({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 3),
        Text(value, style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceMed)),
      ],
    );
  }
}
