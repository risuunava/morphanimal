import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.onSurface,
        onPrimary: AppColors.surface,
        secondary: ElementColors.palettes['water']?.primary ?? Colors.blue,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        error: SemanticColors.error,
        onError: Colors.white,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        headlineLarge: AppTextStyles.headingLarge,
        headlineMedium: AppTextStyles.headingMedium,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        labelLarge: AppTextStyles.labelLarge,
        labelSmall: AppTextStyles.labelSmall,
      ).apply(
        bodyColor: AppColors.onSurface,
        displayColor: AppColors.onSurface,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headingMedium,
        iconTheme: IconThemeData(color: AppColors.onSurface),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: AppColors.onSurface,
        unselectedItemColor: AppColors.onSurfaceLow,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceDim,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.onSurface, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
