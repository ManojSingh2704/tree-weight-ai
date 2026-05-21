import 'package:flutter/material.dart';

class TreeWeightTheme {
  static const _forest = Color(0xFF176B3A);
  static const _leaf = Color(0xFF2FA866);
  static const _soil = Color(0xFF5A3A21);
  static const _cream = Color(0xFFF7F3E8);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _forest,
      primary: _forest,
      secondary: _leaf,
      tertiary: _soil,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _cream,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: _cream,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
