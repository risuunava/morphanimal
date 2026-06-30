import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/creature.dart';

class CreatureCard extends StatelessWidget {
  final Creature creature;
  final VoidCallback? onTap;
  final bool compact;

  const CreatureCard({
    super.key,
    required this.creature,
    this.onTap,
    this.compact = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = ElementColors.palettes[creature.element];
    final bg       = palette?.background ?? AppColors.surfaceDim;
    final primary  = palette?.primary    ?? AppColors.onSurface;

    return Hero(
      tag: 'creature_card_${creature.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          splashColor: primary.withValues(alpha: 0.15),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadows.cardShadowColored(primary),
            ),
            child: compact ? _buildCompact(palette, primary) : _buildFull(palette, primary),
          ),
        ),
      ),
    );
  }

  Widget _buildCompact(ElementPalette? palette, Color primary) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Artwork area
          Expanded(
            child: Center(
              child: creature.imagePath.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(creature.imagePath, fit: BoxFit.cover),
                    )
                  : Text(_elementEmoji(creature.element), style: const TextStyle(fontSize: 52)),
            ),
          ),
          const SizedBox(height: 8),
          // Rarity + element badges
          Row(
            children: [
              _SmallBadge(text: creature.element, color: primary),
              const SizedBox(width: 4),
              _RarityDot(rarity: creature.rarity),
            ],
          ),
          const SizedBox(height: 4),
          // Name
          Text(
            creature.creatureName,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          // Number
          Text(
            'No.${creature.id.substring(0, 4).toUpperCase()}',
            style: AppTextStyles.numberBadge.copyWith(color: AppColors.onSurfaceMed),
          ),
        ],
      ),
    );
  }

  Widget _buildFull(ElementPalette? palette, Color primary) {
    return Padding(
      padding: AppSpacing.cardPadding,
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: creature.imagePath.isNotEmpty
                  ? Image.asset(creature.imagePath, fit: BoxFit.cover)
                  : Text(_elementEmoji(creature.element), style: const TextStyle(fontSize: 36)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(creature.creatureName, style: AppTextStyles.headingMedium),
                const SizedBox(height: 4),
                Row(children: [
                  _SmallBadge(text: creature.element, color: primary),
                  const SizedBox(width: 6),
                  _SmallBadge(
                    text: creature.rarity,
                    color: RarityColors.palettes[creature.rarity]?.color ?? Colors.grey,
                  ),
                ]),
                const SizedBox(height: 4),
                Text(
                  'Lv.${creature.level}  HP ${creature.hp}  ATK ${creature.atk}',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.onSurfaceMed),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.onSurfaceLow),
        ],
      ),
    );
  }

  String _elementEmoji(String element) {
    return switch (element) {
      'fire'     => '🔥',
      'water'    => '💧',
      'shadow'   => '🌑',
      'electric' => '⚡',
      'nature'   => '🌿',
      'light'    => '✨',
      'wind'     => '🌀',
      'earth'    => '🪨',
      'ice'      => '❄️',
      'poison'   => '☠️',
      _          => '🐾',
    };
  }
}

class _SmallBadge extends StatelessWidget {
  final String text;
  final Color color;
  const _SmallBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(color: color),
      ),
    );
  }
}

class _RarityDot extends StatelessWidget {
  final String rarity;
  const _RarityDot({required this.rarity});

  @override
  Widget build(BuildContext context) {
    final color = RarityColors.palettes[rarity]?.color ?? Colors.grey;
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
