import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class RarityBadge extends StatelessWidget {
  final String rarity;
  const RarityBadge({super.key, required this.rarity});

  @override
  Widget build(BuildContext context) {
    final isLegendary = rarity == 'legendary';
    final palette = RarityColors.palettes[rarity];
    final color = palette?.color ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLegendary ? Colors.transparent : color.withValues(alpha: 0.2),
        border: isLegendary
            ? Border.all(color: Colors.amber, width: 1.5)
            : null,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        rarity.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: isLegendary ? Colors.amber : color,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
