import 'package:flutter/material.dart';
import '../../../domain/entities/creature.dart';
import '../../../domain/entities/player.dart';
import '../../../core/theme/app_colors.dart';

/// Widget 1080×1080 yang di-screenshot lalu di-share.
/// Harus dirender di dalam `Screenshot` controller di `DetailScreen`.
class ShareCardWidget extends StatelessWidget {
  final Creature creature;
  final Player? player;

  const ShareCardWidget({
    super.key,
    required this.creature,
    this.player,
  });

  @override
  Widget build(BuildContext context) {
    final palette = ElementColors.palettes[creature.element];
    final bg1 = palette?.background ?? AppColors.surfaceDim;
    final primary = palette?.primary ?? AppColors.captureOrange;
    final rarityColor = RarityColors.palettes[creature.rarity]?.color ?? Colors.grey;

    return SizedBox(
      width: 1080,
      height: 1080,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              bg1,
              primary.withValues(alpha: 0.3),
              AppColors.background,
            ],
            stops: const [0, 0.5, 1],
          ),
        ),
        child: Stack(
          children: [
            // ─── Background decorative circles ──────────────────────────
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: 0.06),
                ),
              ),
            ),

            // ─── Main content ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top: App brand
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: primary.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          'MORPHANIMAL',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 20,
                            color: primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Center: Creature artwork
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow ring
                        Container(
                          width: 420,
                          height: 420,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                primary.withValues(alpha: 0.25),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        // Image or emoji
                        Container(
                          width: 340,
                          height: 340,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primary.withValues(alpha: 0.1),
                            border: Border.all(
                              color: primary.withValues(alpha: 0.3),
                              width: 3,
                            ),
                          ),
                          child: creature.imagePath.isNotEmpty
                              ? ClipOval(
                                  child: Image.asset(
                                    creature.imagePath,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    _elementEmoji(creature.element),
                                    style: const TextStyle(fontSize: 160),
                                  ),
                                ),
                        ),
                        // Rarity badge (top-right of image)
                        Positioned(
                          top: 60,
                          right: 60,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: rarityColor,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: rarityColor.withValues(alpha: 0.5),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Text(
                              creature.rarity.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Bottom: Name, stats, capture info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Creature name
                      Text(
                        creature.creatureName,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 64,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          height: 1.1,
                          shadows: [Shadow(color: Colors.black38, blurRadius: 12)],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Species
                      Text(
                        creature.commonName,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 28,
                          color: Colors.white.withValues(alpha: 0.6),
                          fontStyle: FontStyle.italic,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Stats row
                      Row(
                        children: [
                          _StatPill(label: 'HP', value: creature.hp, color: Colors.greenAccent),
                          const SizedBox(width: 16),
                          _StatPill(label: 'ATK', value: creature.atk, color: Colors.orangeAccent),
                          const SizedBox(width: 16),
                          _StatPill(label: 'DEF', value: creature.def, color: Colors.blueAccent),
                          const SizedBox(width: 16),
                          _StatPill(label: 'SPD', value: creature.spd, color: Colors.purpleAccent),
                          const Spacer(),
                          // Element badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: primary.withValues(alpha: 0.5)),
                            ),
                            child: Text(
                              creature.element.toUpperCase(),
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Captured by + hashtag
                      Row(
                        children: [
                          Text(
                            'Ditangkap oleh ${player?.name ?? 'Hunter'}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 22,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '#MorphanimalCollector',
                            style: TextStyle(
                              color: primary.withValues(alpha: 0.8),
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _elementEmoji(String element) => switch (element) {
    'fire' => '🔥',
    'water' => '💧',
    'shadow' => '🌑',
    'electric' => '⚡',
    'nature' => '🌿',
    'light' => '✨',
    'wind' => '🌀',
    'earth' => '🪨',
    'ice' => '❄️',
    'poison' => '☠️',
    _ => '🐾',
  };
}

class _StatPill extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatPill({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            '$value',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
