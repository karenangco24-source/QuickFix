
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryYellow = Color(0xFFFFC928);
  static const Color darkText = Color(0xFF252525);
  static const Color background = Color(0xFFFFFDF6);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color mutedText = Color(0xFF777777);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryYellow,
        brightness: Brightness.light,
        surface: background,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardWhite,
        indicatorColor: primaryYellow.withValues(alpha: 0.35),
        labelTextStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E3D7)),
        ),
      ),
    );
  }
}
