import 'package:flutter/material.dart';

class AppTheme {
  static const Color _primary = Color(0xFF4C7CF6);
  static const Color _accent = Color(0xFFF5A524);
  static const Color _error = Color(0xFFE44F4F);
  static const Color _bg = Color(0xFFF8FAFC);
  static const Color _text = Color(0xFF0F172A);

  static ThemeData get light {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primary,
        primary: _primary,
        secondary: _accent,
        surface: _bg,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      useMaterial3: true,
    );
  }
}
