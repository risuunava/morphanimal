import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/creature.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/constants/skill_database.dart';
import '../../widgets/stat_bar.dart';
import 'package:screenshot/screenshot.dart';
import '../../../core/utils/share_utils.dart';
import '../../../game/resolvers/name_generator.dart';

class DetailScreen extends StatefulWidget {
  final Creature creature;
  const DetailScreen({super.key, required this.creature});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final creature = widget.creature;
    final palette = ElementColors.palettes[creature.element];
    final bg      = palette?.background ?? AppColors.surfaceDim;
    final primary = palette?.primary    ?? AppColors.onSurface;

    return Screenshot(
      controller: _screenshotController,
      child: Scaffold(
        backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ─── Header App Bar (Artwork) ──────────────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: primary,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  creature.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  // TODO: Toggle favorite logic
                },
              ),
              IconButton(
                icon: const Icon(Icons.share_rounded, color: Colors.white),
                onPressed: () => ShareUtils.shareCreatureCard(
                  context: context,
                  creature: creature,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'creature_card_${creature.id}',
                child: Container(
                  color: bg,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Backdrop glow
                      Container(
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primary.withValues(alpha: 0.3),
                              blurRadius: 50,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      // Image
                      if (creature.imagePath.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            creature.imagePath,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        )
                      else
                        Text(
                          _elementEmoji(creature.element),
                          style: const TextStyle(fontSize: 100),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ─── Info Content ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama & Spesies
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(creature.creatureName, style: AppTextStyles.displayLarge),
                            const SizedBox(height: 4),
                            Text(
                              '${creature.commonName} (${creature.species})',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurfaceMed,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            if (creature.species == 'unknown')
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  unknownBeastFlavor,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.onSurfaceMed,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        'Lv.${creature.level}',
                        style: AppTextStyles.headingLarge.copyWith(color: primary),
                      ),
                    ],
                  ).animate().fadeIn().slideY(begin: 0.2),

                  const SizedBox(height: 20),

                  // Badges
                  Row(
                    children: [
                      _Badge(text: creature.element, color: primary),
                      const SizedBox(width: 8),
                      _Badge(
                        text: creature.rarity,
                        color: RarityColors.palettes[creature.rarity]?.color ?? Colors.grey,
                      ),
                    ],
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),

                  const SizedBox(height: 32),

                  // Stats
                  const Text('Status', style: AppTextStyles.headingMedium)
                      .animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 16),
                  Container(
                    padding: AppSpacing.cardPadding,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: AppShadows.cardShadow,
                    ),
                    child: Column(
                      children: [
                        StatBar(label: 'HP', value: creature.hp, color: SemanticColors.hpColor(creature.hp / 350)),
                        const SizedBox(height: 12),
                        StatBar(label: 'ATK', value: creature.atk, color: AppColors.captureOrange),
                        const SizedBox(height: 12),
                        StatBar(label: 'DEF', value: creature.def, color: Colors.blueAccent),
                        const SizedBox(height: 12),
                        StatBar(label: 'SPD', value: creature.spd, color: Colors.purpleAccent),
                      ],
                    ),
                  ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.2),

                  const SizedBox(height: 32),

                  // Skills
                  const Text('Skills', style: AppTextStyles.headingMedium)
                      .animate().fadeIn(delay: 350.ms),
                  const SizedBox(height: 16),
                  ...creature.skillIds.map((skillId) {
                    final skill = _findSkill(skillId);
                    if (skill == null) return const SizedBox.shrink();
                    return _SkillItem(skill: skill, color: primary)
                        .animate().fadeIn(delay: 400.ms).slideX(begin: 0.1);
                  }),

                  const SizedBox(height: 32),

                  // Meta Info (Ditangkap tanggal)
                  Center(
                    child: Text(
                      'Ditangkap: ${DateFormat('dd MMM yyyy, HH:mm').format(creature.capturedAt)}\n'
                      'ID: ${creature.id}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceLow),
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
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

  SkillData? _findSkill(String id) {
    for (final list in skillsByElement.values) {
      for (final skill in list) {
        if (skill.id == id) return skill;
      }
    }
    return null;
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        text.toUpperCase(),
        style: AppTextStyles.labelLarge.copyWith(color: color, letterSpacing: 1),
      ),
    );
  }
}

class _SkillItem extends StatelessWidget {
  final SkillData skill;
  final Color color;
  const _SkillItem({required this.skill, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceDim),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.flash_on_rounded, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(skill.name, style: AppTextStyles.labelLarge),
                const SizedBox(height: 4),
                Text(
                  'PWR ${skill.power} | ACC ${skill.accuracy}% | PP ${skill.pp}',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurfaceMed),
                ),
                if (skill.effect != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Effect: ${skill.effect}',
                    style: AppTextStyles.labelSmall.copyWith(color: Colors.redAccent),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
