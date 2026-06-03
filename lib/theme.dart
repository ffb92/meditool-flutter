import 'package:flutter/material.dart';

class AppTheme {
  static const cyan = Color(0xFF0891B2);
  static const teal = Color(0xFF14B8A6);
  static const bg = Color(0xFF0F172A);
  static const card = Color(0xFF1E293B);
  static const text = Color(0xFFE2E8F0);
  static const muted = Color(0xFF94A3B8);
  static const red = Color(0xFFEF4444);
  static const amber = Color(0xFFF59E0B);
  static const green = Color(0xFF10B981);

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bg,
    primaryColor: cyan,
    colorScheme: const ColorScheme.dark(primary: cyan, secondary: teal, surface: card, error: red),
    appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, centerTitle: false),
  );
}
