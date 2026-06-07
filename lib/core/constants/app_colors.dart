import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary brand palette
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E3A8A);
  static const Color primarySurface = Color(0xFFEFF6FF);

  // Accent / highlight
  static const Color accent = Color(0xFF06B6D4);
  static const Color accentLight = Color(0xFFCFFAFE);

  // Semantic
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFE0F2FE);

  // Neutral / Text
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textInverse = Color(0xFFFFFFFF);

  // Backgrounds
  static const Color background = Color(0xFFF1F5F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFAFAFA);
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderLight = Color(0xFFF3F4F6);
  static const Color divider = Color(0xFFE5E7EB);

  // Gradient stops
  static const Color gradientStart = Color(0xFF1A56DB);
  static const Color gradientEnd = Color(0xFF1E3A8A);

  // Status chip colors
  static const Color statusNew = Color(0xFF0284C7);
  static const Color statusNewBg = Color(0xFFE0F2FE);
  static const Color statusContacted = Color(0xFFD97706);
  static const Color statusContactedBg = Color(0xFFFEF3C7);
  static const Color statusConverted = Color(0xFF059669);
  static const Color statusConvertedBg = Color(0xFFD1FAE5);
  static const Color statusLost = Color(0xFFDC2626);
  static const Color statusLostBg = Color(0xFFFEE2E2);
  static const Color statusQualified = Color(0xFF7C3AED);
  static const Color statusQualifiedBg = Color(0xFFEDE9FE);
}
