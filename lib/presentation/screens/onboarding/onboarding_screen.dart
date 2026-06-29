import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../domain/entities/player.dart';
import '../../providers/providers.dart';

const _kFirstTimeKey = 'is_first_time';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  final _nameController = TextEditingController();
  int _currentPage = 0;
  bool _showNameInput = false;
  bool _saving = false;

  static const _slides = [
    _SlideData(
      emoji: '🌍',
      title: 'Dunia Nyata,\nMonster Fantasi',
      subtitle: 'Hewan di sekitarmu berubah jadi kreatur ajaib. Selalu ada yang belum kamu temukan!',
      gradientColors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    ),
    _SlideData(
      emoji: '📸',
      title: 'Foto Hewan →\nDapat Kreatur',
      subtitle: 'AI kami mendeteksi spesies, lalu menghasilkan Morphanimal unik yang hanya milikmu.',
      gradientColors: [Color(0xFF0F3460), Color(0xFF533483)],
    ),
    _SlideData(
      emoji: '⚔️',
      title: 'Koleksi, Battle,\nJadi Hunter Terkuat!',
      subtitle: 'Bangun tim, tantang Hunter lain, dan kuasai Bestiary lengkap.',
      gradientColors: [Color(0xFF533483), Color(0xFFE94560)],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _savePlayer() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _saving = true);

    final player = Player(
      id: 'player_1',
      name: name,
      level: 1,
      xp: 0,
      gold: 0,
      streak: 0,
      lastLogin: DateTime.now(),
      achievements: [],
      battleTeamIds: [],
    );

    await ref.read(playerRepositoryProvider).save(player);

    // Set first-time flag selesai
    final box = Hive.box<bool>('settings');
    await box.put(_kFirstTimeKey, false);

    if (mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showNameInput ? _buildNameInput() : _buildSlides(),
    );
  }

  Widget _buildSlides() {
    final slide = _slides[_currentPage];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: slide.gradientColors,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => setState(() => _showNameInput = true),
                child: Text(
                  'Lewati',
                  style: AppTextStyles.labelLarge.copyWith(color: Colors.white60),
                ),
              ),
            ),

            // Slide content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) {
                  final s = _slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(s.emoji, style: const TextStyle(fontSize: 100))
                            .animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                        const SizedBox(height: 40),
                        Text(
                          s.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
                        ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                        const SizedBox(height: 16),
                        Text(
                          s.subtitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
                        ).animate().fadeIn(delay: 350.ms),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Dot indicator + nav buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 48),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _slides.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.white30,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () {
                      if (_currentPage < _slides.length - 1) {
                        _pageController.nextPage(
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                        );
                      } else {
                        setState(() => _showNameInput = true);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: slide.gradientColors.last,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      _currentPage < _slides.length - 1 ? 'Lanjut' : 'Mulai Petualangan!',
                      style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameInput() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('👤', style: TextStyle(fontSize: 72))
                  .animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
              const SizedBox(height: 32),
              Text(
                'Siapa nama\nHunter-mu?',
                textAlign: TextAlign.center,
                style: AppTextStyles.displayLarge.copyWith(color: Colors.white),
              ).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 8),
              Text(
                'Nama ini akan muncul di profil dan kartu share.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white60),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 40),
              TextField(
                controller: _nameController,
                maxLength: 20,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingLarge.copyWith(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Masukkan namamu...',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(color: Colors.white30),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white30),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                  ),
                  counterStyle: const TextStyle(color: Colors.white30),
                ),
              ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _saving ? null : _savePlayer,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF1A1A2E),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _saving
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(
                        'Mulai Berburu! 🎯',
                        style: AppTextStyles.labelLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
              ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}

class _SlideData {
  final String emoji;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  const _SlideData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
  });
}
