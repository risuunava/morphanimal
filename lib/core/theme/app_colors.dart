import 'package:flutter/material.dart';

class ElementPalette {
  final Color background;
  final Color primary;
  final Color gradient;
  final Color text;
  final Color badgeText;

  const ElementPalette({
    required this.background,
    required this.primary,
    required this.gradient,
    required this.text,
    required this.badgeText,
  });
}

class RarityPalette {
  final Color color;
  final Color shimmer;
  final String label;

  const RarityPalette({
    required this.color,
    required this.shimmer,
    required this.label,
  });
}

class AppColors {
  // Neutrals
  static const Color background   = Color(0xFFF5F5F5); // Abu sangat terang
  static const Color surface      = Color(0xFFFFFFFF); // Card putih
  static const Color surfaceDim   = Color(0xFFF0F0F0); // Divider, subtle bg
  static const Color onSurface    = Color(0xFF1A1A2E); // Teks utama (near-black biru)
  static const Color onSurfaceMed = Color(0xFF6B6B8A); // Teks sekunder
  static const Color onSurfaceLow = Color(0xFFABABBF); // Teks muted, placeholder
  
  // Capture
  static const Color captureOrange = Color(0xFFFF6B35);

  // Overlay
  static const Color scrim        = Color(0x80000000); // Modal backdrop
}

class ElementColors {
  static const Map<String, ElementPalette> palettes = {
    'fire': ElementPalette(
      background: Color(0xFFFFEBE0),
      primary:    Color(0xFFFF6B35),
      gradient:   Color(0xFFFF4500),
      text:       Color(0xFF8B2500),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'water': ElementPalette(
      background: Color(0xFFE0F4FF),
      primary:    Color(0xFF2196F3),
      gradient:   Color(0xFF0D47A1),
      text:       Color(0xFF0A2E6E),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'nature': ElementPalette(
      background: Color(0xFFE8F5E9),
      primary:    Color(0xFF4CAF50),
      gradient:   Color(0xFF1B5E20),
      text:       Color(0xFF1B5E20),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'electric': ElementPalette(
      background: Color(0xFFFFFDE7),
      primary:    Color(0xFFFFD600),
      gradient:   Color(0xFFF57F17),
      text:       Color(0xFF6D4C00),
      badgeText:  Color(0xFF3D2800),
    ),
    'shadow': ElementPalette(
      background: Color(0xFFEDE7F6),
      primary:    Color(0xFF7B1FA2),
      gradient:   Color(0xFF311B92),
      text:       Color(0xFF1A0033),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'light': ElementPalette(
      background: Color(0xFFFFFDE7),
      primary:    Color(0xFFFFEB3B),
      gradient:   Color(0xFFFBC02D),
      text:       Color(0xFF4A3700),
      badgeText:  Color(0xFF4A3700),
    ),
    'wind': ElementPalette(
      background: Color(0xFFE3F2FD),
      primary:    Color(0xFF29B6F6),
      gradient:   Color(0xFF01579B),
      text:       Color(0xFF003060),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'earth': ElementPalette(
      background: Color(0xFFFBE9E7),
      primary:    Color(0xFF8D6E63),
      gradient:   Color(0xFF3E2723),
      text:       Color(0xFF3E2723),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'ice': ElementPalette(
      background: Color(0xFFE0F7FA),
      primary:    Color(0xFF80DEEA),
      gradient:   Color(0xFF006064),
      text:       Color(0xFF004D54),
      badgeText:  Color(0xFF004D54),
    ),
    'poison': ElementPalette(
      background: Color(0xFFF3E5F5),
      primary:    Color(0xFFAB47BC),
      gradient:   Color(0xFF6A1B9A),
      text:       Color(0xFF3A0060),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'unknown': ElementPalette(
      background: Color(0xFFF5F5F5),
      primary:    Color(0xFF9E9E9E),
      gradient:   Color(0xFF424242),
      text:       Color(0xFF212121),
      badgeText:  Color(0xFFFFFFFF),
    ),
  };
}

class RarityColors {
  static const Map<String, RarityPalette> palettes = {
    'common': RarityPalette(
      color:     Color(0xFF9E9E9E),
      shimmer:   Color(0xFFBDBDBD),
      label:     'Common',
    ),
    'rare': RarityPalette(
      color:     Color(0xFF2196F3),
      shimmer:   Color(0xFF64B5F6),
      label:     'Rare',
    ),
    'epic': RarityPalette(
      color:     Color(0xFF9C27B0),
      shimmer:   Color(0xFFCE93D8),
      label:     'Epic',
    ),
    'legendary': RarityPalette(
      color:     Color(0xFFFFD600),
      shimmer:   Color(0xFFFFEE58),
      label:     'Legendary',
    ),
  };
}

class SemanticColors {
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error   = Color(0xFFF44336);
  static const Color info    = Color(0xFF2196F3);

  static Color hpColor(double percent) {
    if (percent > 0.5) return const Color(0xFF4CAF50); // Hijau
    if (percent > 0.2) return const Color(0xFFFF9800); // Oranye
    return const Color(0xFFF44336);                    // Merah
  }
}
