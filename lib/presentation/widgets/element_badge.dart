import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ElementBadge extends StatelessWidget {
  final String element;
  const ElementBadge({super.key, required this.element});

  @override
  Widget build(BuildContext context) {
    final palette = ElementColors.palettes[element];
    final color = palette?.primary ?? Colors.grey;
    final textColor = palette?.badgeText ?? Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        element.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
