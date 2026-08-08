import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF6C63A8);
  static const Color background = Color(0xFFFFFBF5);
  static const Color darkText = Color(0xFF29263D);
  static const Color secondaryText = Color(0xFF666274);
  static const Color lightPrimary = Color(0xFFE8E4F7);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
  );
}