import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class StatBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color? color;

  const StatBar({
    super.key,
    required this.label,
    required this.value,
    this.maxValue = 350,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final fraction = (value / maxValue).clamp(0.0, 1.0);
    final barColor = color ?? AppColors.onSurface;

    return Row(
      children: [
        // Label — fixed 44dp
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.onSurfaceMed,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 10),
        // Bar
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return Stack(
              children: [
                // Background track
                Container(
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDim,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                // Foreground fill
                Container(
                  height: 7,
                  width: constraints.maxWidth * fraction,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                )
                    .animate()
                    .custom(
                      duration: 800.ms,
                      delay: 100.ms,
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Container(
                          height: 7,
                          width: constraints.maxWidth * fraction * value,
                          decoration: BoxDecoration(
                            color: barColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                        );
                      },
                    ),
              ],
            );
          }),
        ),
        const SizedBox(width: 10),
        // Value — fixed 38dp
        SizedBox(
          width: 38,
          child: Text(
            '$value',
            style: AppTextStyles.statNumber.copyWith(color: AppColors.onSurface),
            textAlign: TextAlign.left,
          ),
        ),
      ],
    );
  }
}
