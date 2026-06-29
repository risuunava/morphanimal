import 'package:flutter/material.dart';

class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;

  // Padding halaman utama
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 16.0,
  );

  // Padding card
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(12.0);
}

class AppRadius {
  static const double xs   = 8.0;
  static const double sm   = 12.0;
  static const double md   = 20.0;   // Dipakai di creature card
  static const double lg   = 28.0;   // Dipakai di bottom sheet
  static const double full = 100.0;  // Pill badge (elemen, rarity)

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(full));
}

class AppShadows {
  // Card normal
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  // Card yang sedang dipilih / active
  static List<BoxShadow> cardShadowColored(Color elementColor) {
    return [
      BoxShadow(
        color: elementColor.withValues(alpha: 0.30),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
      BoxShadow(
        color: elementColor.withValues(alpha: 0.10),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  // Bottom navigation bar
  static const List<BoxShadow> navBarShadow = [
    BoxShadow(
      color: Color(0x18000000),
      blurRadius: 24,
      offset: Offset(0, -4),
    ),
  ];
}
