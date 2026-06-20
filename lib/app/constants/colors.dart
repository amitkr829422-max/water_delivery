import 'package:flutter/material.dart';

class AppColors {
  // Light Theme Colors (हल्के कलर्स)
  static const Color primaryLight = Color(0xFF006494);
  static const Color secondaryLight = Color(0xFF00A8E8);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Colors.white;
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textSecondaryLight = Color(0xFF64748B);

  // Dark Theme Colors (प्रीमियम गहरा स्लेट कलर)
  static const Color primaryDark = Color(0xFF00A8E8);
  static const Color secondaryDark = Color(0xFF006494);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF8FAFC);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // Status Colors (स्टेटस कलर्स)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // Premium Gradients (खूबसूरत ग्रेडिएंट्स)
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF006494), Color(0xFF00A8E8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
