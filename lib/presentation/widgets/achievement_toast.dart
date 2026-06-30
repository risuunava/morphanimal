import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/achievement_constants.dart';

class AchievementToast {
  static void show(BuildContext context, AchievementDefinition achievement) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: _ToastWidget(
            achievement: achievement,
            onDismiss: () => entry.remove(),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    
    // Auto hapus setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) entry.remove();
    });
  }
}

class _ToastWidget extends StatelessWidget {
  final AchievementDefinition achievement;
  final VoidCallback onDismiss;

  const _ToastWidget({required this.achievement, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    Color tierColor;
    switch (achievement.tier) {
      case 'bronze': tierColor = const Color(0xFFCD7F32); break;
      case 'silver': tierColor = const Color(0xFFC0C0C0); break;
      case 'gold': tierColor = const Color(0xFFFFD700); break;
      default: tierColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tierColor.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: tierColor.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: tierColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(achievement.icon, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text('🏆 Achievement Unlocked!', style: TextStyle(fontSize: 10, color: AppColors.captureOrange, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('+${achievement.xpReward} XP', style: AppTextStyles.labelSmall.copyWith(color: tierColor)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(achievement.title, style: AppTextStyles.headingMedium.copyWith(color: AppColors.onSurface)),
                Text(achievement.description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceMed)),
              ],
            ),
          ),
        ],
      ),
    )
    .animate()
    .slideY(begin: -1, duration: 400.ms, curve: Curves.easeOutBack)
    .fadeIn()
    .then(delay: 2200.ms) // Tahan 2.2 detik
    .slideY(end: -1, duration: 300.ms, curve: Curves.easeIn) // Slide ke atas
    .fadeOut();
  }
}
