import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:confetti/confetti.dart';
import '../../../domain/entities/creature.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_spacing.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../game/achievement_checker.dart';
import '../../../game/resolvers/name_generator.dart';
import '../../widgets/achievement_toast.dart';

class RevealScreen extends ConsumerStatefulWidget {
  const RevealScreen({super.key});

  @override
  ConsumerState<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends ConsumerState<RevealScreen> {
  late ConfettiController _confetti;
  bool _showCta = false;
  late Creature _creature;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 5));
    // Tunggu animasi selesai, baru tampilkan CTA dan confetti
    Future.delayed(const Duration(milliseconds: 2700), () async {
      if (mounted) {
        setState(() => _showCta = true);
        if (_creature.rarity == 'legendary') _confetti.play();
        
        // Cek achievements
        final newAchvs = await ref.read(achievementCheckerProvider).checkAchievements();
        if (mounted) {
          int delay = 0;
          for (final achv in newAchvs) {
            Future.delayed(Duration(milliseconds: delay), () {
              if (mounted) AchievementToast.show(context, achv);
            });
            delay += 2500; // Queue toast
          }
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = GoRouterState.of(context);
    _creature = state.extra as Creature? ??
        Creature(
          id: 'test',
          species: 'Felis catus',
          commonName: 'Kucing',
          creatureName: 'Umbren Claw',
          element: 'shadow',
          rarity: 'epic',
          level: 1,
          xp: 0,
          hp: 180,
          atk: 110,
          def: 90,
          spd: 120,
          ivs: {'hp': 20, 'atk': 18, 'def': 14, 'spd': 25},
          skillIds: ['shad_1', 'shad_2'],
          imagePath: '',
          rawImagePath: '',
          seed: '',
          capturedAt: DateTime.now(),
          isFavorite: false,
        );
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  Color get _elementColor {
    final palette = ElementColors.palettes[_creature.element];
    return palette?.primary ?? AppColors.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ─── Step 1: Background fade ke warna elemen ──────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _elementColor.withValues(alpha: 0.85),
                  AppColors.background,
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms),

          // ─── Confetti (Legendary only) ─────────────────────────────
          if (_creature.rarity == 'legendary')
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 40,
                colors: const [Colors.amber, Colors.orange, Colors.yellow, Colors.white],
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                // ─── Step 5–9: Content ────────────────────────────
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Step 2–4: Orb → Flash → Creature artwork
                      _buildArtwork(),

                      const SizedBox(height: 24),

                      // Step 7: Nama
                      Text(
                        _creature.creatureName,
                        style: AppTextStyles.displayLarge.copyWith(
                          color: Colors.white,
                          shadows: [const Shadow(color: Colors.black38, blurRadius: 8)],
                        ),
                        textAlign: TextAlign.center,
                      )
                          .animate()
                          .slideY(
                            begin: 0.5,
                            duration: 300.ms,
                            delay: 2000.ms,
                            curve: Curves.easeOut,
                          )
                          .fadeIn(delay: 2000.ms, duration: 300.ms),

                      const SizedBox(height: 8),

                      // Step 8: Badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ElementBadgeSimple(element: _creature.element),
                          const SizedBox(width: 8),
                          _RarityBadgeSimple(rarity: _creature.rarity),
                        ],
                      )
                          .animate()
                          .fadeIn(delay: 2300.ms, duration: 200.ms),

                      // Unknown Beast flavor text
                      if (_creature.species == 'unknown') ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            unknownBeastFlavor,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ).animate().fadeIn(delay: 2400.ms, duration: 300.ms),
                      ],

                      const SizedBox(height: 20),

                      // Step 9: Stat preview
                      _buildStatPreview()
                          .animate()
                          .fadeIn(delay: 2500.ms, duration: 200.ms),
                    ],
                  ),
                ),

                // ─── Step 10: CTA Button ──────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                  child: AnimatedOpacity(
                    opacity: _showCta ? 1 : 0,
                    duration: 300.ms,
                    child: AnimatedScale(
                      scale: _showCta ? 1.0 : 0.8,
                      duration: 300.ms,
                      curve: Curves.easeOutBack,
                      child: FilledButton(
                        onPressed: () => context.go('/home/collection'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _elementColor,
                          minimumSize: const Size(double.infinity, 54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Tambah ke Koleksi 🎉',
                          style: AppTextStyles.labelLarge.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArtwork() {
    final hasImage = _creature.imagePath.isNotEmpty;

    return Stack(
      alignment: Alignment.center,
      children: [
        // Step 6: Rarity glow ring
        if (_creature.rarity == 'legendary')
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.amber.withValues(alpha: 0.6), blurRadius: 40, spreadRadius: 10),
              ],
            ),
          )
              .animate()
              .fadeIn(delay: 1700.ms, duration: 300.ms),

        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.15),
            boxShadow: AppShadows.cardShadowColored(_elementColor),
          ),
          child: hasImage
              ? ClipOval(child: Image.asset(_creature.imagePath, fit: BoxFit.cover))
              : Center(
                  child: Text(
                    _elementEmoji(_creature.element),
                    style: const TextStyle(fontSize: 80),
                  ),
                ),
        )
            .animate()
            .scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 400.ms,
              delay: 1300.ms,
              curve: Curves.easeOutBack,
            )
            .fadeIn(delay: 1300.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildStatPreview() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _StatChip(label: 'HP', value: _creature.hp),
        const SizedBox(width: 12),
        _StatChip(label: 'ATK', value: _creature.atk),
        const SizedBox(width: 12),
        _StatChip(label: 'SPD', value: _creature.spd),
      ],
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

class _ElementBadgeSimple extends StatelessWidget {
  final String element;
  const _ElementBadgeSimple({required this.element});

  @override
  Widget build(BuildContext context) {
    final palette = ElementColors.palettes[element];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: palette?.primary ?? Colors.grey,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        element.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: (palette?.badgeText ?? Colors.white),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _RarityBadgeSimple extends StatelessWidget {
  final String rarity;
  const _RarityBadgeSimple({required this.rarity});

  @override
  Widget build(BuildContext context) {
    final isLegendary = rarity == 'legendary';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLegendary ? Colors.transparent : RarityColors.palettes[rarity]?.color.withValues(alpha: 0.2),
        border: isLegendary
            ? Border.all(color: Colors.amber, width: 1.5)
            : null,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        rarity.toUpperCase(),
        style: AppTextStyles.labelSmall.copyWith(
          color: isLegendary ? Colors.amber : (RarityColors.palettes[rarity]?.color ?? Colors.white),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: Colors.white70),
          ),
          Text(
            '$value',
            style: AppTextStyles.statNumber.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
