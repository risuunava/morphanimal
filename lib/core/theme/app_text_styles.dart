import 'package:flutter/material.dart';

class AppTextStyles {
  // Display — nama creature di detail page
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.1,
  );

  // Heading — judul section, nama di card
  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // Body — deskripsi, flavor text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Label — badge elemen, label stat
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Stat numbers — HP angka, ATK angka
  static const TextStyle statNumber = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle statNumberLarge = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );

  // Number badge — No.003 style
  static const TextStyle numberBadge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.0,
  );
}
