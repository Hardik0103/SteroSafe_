import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF2563EB); // Qualcomm/Medical Blue
  static const Color primaryDarkBlue = Color(0xFF1D4ED8);
  static const Color primaryLightBlue = Color(0xFFDBEAFE);
  static const Color accentCyan = Color(0xFF06B6D4);

  // Status & Severity Colors
  static const Color successGreen = Color(0xFF10B981);
  static const Color successLightGreen = Color(0xFFD1FAE5);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color warningLightAmber = Color(0xFFFEF3C7);
  static const Color dangerRed = Color(0xFFEF4444);
  static const Color dangerLightRed = Color(0xFFFEE2E2);
  static const Color dangerDarkRed = Color(0xFF991B1B);

  // Background & Neutral Colors
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color surfaceSubtle = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        surface: surface,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: background,
      fontFamily: 'Segoe UI',
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: textPrimary),
      ),
    );
  }
}
