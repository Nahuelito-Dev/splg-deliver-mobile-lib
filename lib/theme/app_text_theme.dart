import 'package:flutter/material.dart';

TextTheme buildTextTheme(Color textColor) {
  return TextTheme(
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: textColor,
      letterSpacing: -0.25,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: textColor,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: textColor,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: textColor,
      letterSpacing: 0.1,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: textColor,
      letterSpacing: 0.1,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: textColor,
      letterSpacing: 0.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: textColor,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: textColor.withAlpha(60),
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textColor,
      letterSpacing: 0.1,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: textColor.withAlpha(70),
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: textColor.withAlpha(60),
      letterSpacing: 0.5,
    ),
  );
}
