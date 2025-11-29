import 'package:flutter/material.dart';

class AppTheme {
  // Sunset Punch palette
  static const Color _primary = Color(0xFFD14A28); // Harley Davidson Orange
  static const Color _secondary = Color(0xFF3F7BB9); // Seabrook
  static const Color _secondaryDark = Color(0xFF1F2F55); // Dark navy accent
  static const Color _gold = Color(0xFFD6A21F); // Nanohanacha Gold
  static const Color _error = Color(0xFFE44F4F);
  static const Color _bg = Color(0xFFF5F6F8); // Lynx White
  static const Color _text = Color(0xFF2B2F36); // Electromagnetic

  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primary,
        primary: _primary,
        onPrimary: Colors.white,
        secondary: _secondary,
        onSecondary: Colors.white,
        surface: _bg,
        onSurface: _text,
        tertiary: _gold,
        error: _error,
      ),
      scaffoldBackgroundColor: _bg,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.bold, color: _text),
        headlineSmall: TextStyle(fontWeight: FontWeight.w600, color: _text),
        bodyMedium: TextStyle(color: _text),
        labelLarge: TextStyle(fontWeight: FontWeight.w600, color: _text),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: _bg,
        foregroundColor: _text,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          overlayColor: _primary.withOpacity(0.12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _secondary,
          side: const BorderSide(color: _secondary, width: 1.4),
          minimumSize: const Size.fromHeight(44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.pressed)
                ? _secondary.withOpacity(0.14)
                : _secondary.withOpacity(0.08),
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        surfaceTintColor: Colors.white,
        shadowColor: _secondary.withAlpha(32),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _secondary.withOpacity(0.08),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, color: _secondaryDark),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        selectedColor: _primary.withOpacity(0.12),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      useMaterial3: true,
    );
  }
}
