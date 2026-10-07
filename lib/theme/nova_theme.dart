import 'package:flutter/material.dart';

class NovaTheme {
  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF080A12),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF7C4DFF),
        secondary: Color(0xFF00D9FF),
        surface: Color(0xFF111522),
      ),
      useMaterial3: true,
    );
  }
}
