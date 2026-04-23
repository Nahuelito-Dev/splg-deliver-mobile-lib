import 'package:flutter/material.dart';

import 'package:jennygas_lib/theme/app_text_colors.dart';
import 'package:jennygas_lib/theme/app_text_theme.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      background: AppColors.background,
      surface: AppColors.surface,
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      elevation: 0,
      centerTitle: true,
    ),

    textTheme: buildTextTheme(AppTextColors.lightPrimary),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    ),

    dividerColor: AppColors.divider,
  );

  // ─────────────────────────────────────────────────────────────

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundDark,

    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondaryLight,
      onSecondary: AppColors.onSecondary,
      background: AppColors.backgroundDark,
      surface: AppColors.surfaceDark,
      error: AppColors.error,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
    ),

    textTheme: buildTextTheme(AppTextColors.darkPrimary),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.onSecondary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    ),

    dividerColor: AppColors.dividerDark,
  );
}

// final ThemeData lightTheme = ThemeData(
//   useMaterial3: true,
//   colorScheme: lightColorScheme,
//   textTheme: buildTextTheme(lightColorScheme.onBackground),
//   scaffoldBackgroundColor: lightColorScheme.background,
//   appBarTheme: AppBarTheme(
//     backgroundColor: lightColorScheme.surface,
//     foregroundColor: lightColorScheme.onSurface,
//     elevation: 0,
//     titleTextStyle: GoogleFonts.poppins(
//       fontSize: 20,
//       fontWeight: FontWeight.w600,
//       color: lightColorScheme.onSurface,
//     ),
//   ),
//   cardTheme: CardThemeData(
//     color: lightColorScheme.surface,
//     elevation: 2,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: lightColorScheme.surface,
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
//       borderRadius: BorderRadius.circular(12),
//     ),
//   ),
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: lightColorScheme.primary,
//     foregroundColor: lightColorScheme.onPrimary,
//   ),
//   iconTheme: IconThemeData(color: lightColorScheme.onSurface),
//   dividerColor: lightColorScheme.outline,
//   chipTheme: ChipThemeData(
//     backgroundColor: lightColorScheme.secondary.withAlpha(10),
//     labelStyle: TextStyle(color: lightColorScheme.onSurface),
//     side: BorderSide(color: lightColorScheme.outline),
//   ),
// );

// final ThemeData darkTheme = ThemeData(
//   useMaterial3: true,
//   colorScheme: darkColorScheme,
//   textTheme: buildTextTheme(darkColorScheme.onBackground),
//   scaffoldBackgroundColor: darkColorScheme.background,
//   appBarTheme: AppBarTheme(
//     backgroundColor: darkColorScheme.surface,
//     foregroundColor: darkColorScheme.onSurface,
//     elevation: 0,
//     titleTextStyle: GoogleFonts.poppins(
//       fontSize: 20,
//       fontWeight: FontWeight.w600,
//       color: darkColorScheme.onSurface,
//     ),
//   ),
//   cardTheme: CardThemeData(
//     color: darkColorScheme.surface,
//     elevation: 2,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     filled: true,
//     fillColor: darkColorScheme.surface,
//     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
//       borderRadius: BorderRadius.circular(12),
//     ),
//   ),
//   floatingActionButtonTheme: FloatingActionButtonThemeData(
//     backgroundColor: darkColorScheme.primary,
//     foregroundColor: darkColorScheme.onPrimary,
//   ),
//   iconTheme: IconThemeData(color: darkColorScheme.onSurface),
//   dividerColor: darkColorScheme.outline,
//   chipTheme: ChipThemeData(
//     backgroundColor: darkColorScheme.secondary.withAlpha(15),
//     labelStyle: TextStyle(color: darkColorScheme.onSurface),
//     side: BorderSide(color: darkColorScheme.outline),
//   ),
// );
