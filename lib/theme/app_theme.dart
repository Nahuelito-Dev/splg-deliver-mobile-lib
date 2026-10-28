import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_colors.dart';
import 'app_text_theme.dart';
import 'brasa_palette.dart';

/// Tema único de las apps, equivalente al `muiTheme` del panel.
class AppTheme {
  AppTheme._();

  /// Misma tipografía que el panel web (declarada en el pubspec de esta lib).
  static const String fontFamily = 'Geist';

  static final ThemeData lightTheme = _build(
    brightness: Brightness.light,
    palette: BrasaPalette.light,
    canvas: AppColors.canvas,
    surface: AppColors.surface,
    ink: AppTextColors.lightPrimary,
    muted: AppTextColors.lightTertiary,
    error: AppColors.danger,
  );

  static final ThemeData darkTheme = _build(
    brightness: Brightness.dark,
    palette: BrasaPalette.dark,
    canvas: AppColors.darkCanvas,
    surface: AppColors.darkSurface,
    ink: AppTextColors.darkPrimary,
    muted: AppTextColors.darkTertiary,
    error: AppColors.darkDanger,
  );

  static ThemeData _build({
    required Brightness brightness,
    required BrasaPalette palette,
    required Color canvas,
    required Color surface,
    required Color ink,
    required Color muted,
    required Color error,
  }) {
    final isDark = brightness == Brightness.dark;
    final radius = BorderRadius.circular(AppRadii.md);
    final outlineBorder = OutlineInputBorder(
      borderRadius: radius,
      borderSide: BorderSide(color: palette.outlineStrong),
    );

    // En oscuro el primario es la variante clara (`primaryStrong`): como texto
    // sobre superficies oscuras la llama #C2470C sólo da ~3,3:1.
    final primary = isDark ? AppColors.darkPrimaryStrong : AppColors.primary;
    final onPrimary = isDark ? AppColors.tinta950 : AppColors.onPrimary;

    final scheme = ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: palette.primarySoft,
      onPrimaryContainer: palette.primaryStrong,
      secondary: AppColors.gas400,
      onSecondary: AppColors.tinta900,
      secondaryContainer: palette.accentSoft,
      onSecondaryContainer: palette.onAccent,
      error: error,
      onError: isDark ? AppColors.tinta950 : AppColors.onPrimary,
      errorContainer: palette.dangerSoft,
      onErrorContainer: palette.danger,
      surface: surface,
      onSurface: ink,
      onSurfaceVariant: palette.muted,
      surfaceTint: Colors.transparent,
      surfaceContainerLowest: surface,
      surfaceContainerLow: surface,
      surfaceContainer: surface,
      surfaceContainerHigh: palette.surfaceSunken,
      surfaceContainerHighest: palette.surfaceMuted,
      outline: palette.faint,
      outlineVariant: palette.outline,
      shadow: AppColors.tinta900,
      scrim: AppColors.tinta900,
      inverseSurface: isDark ? AppColors.darkInk : AppColors.tinta900,
      onInverseSurface: isDark ? AppColors.tinta900 : AppColors.tinta50,
      inversePrimary: AppColors.llama300,
    );

    final buttonShape = RoundedRectangleBorder(borderRadius: radius);
    const buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 14);
    // `ButtonStyleButton` reemplaza el estilo de texto (no lo mezcla con el del
    // tema), así que la fuente va declarada acá.
    const buttonText = TextStyle(
      fontFamily: AppTheme.fontFamily,
      package: 'splg_lib',
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: AppTheme.fontFamily,
      package: 'splg_lib',
      brightness: brightness,
      colorScheme: scheme,
      // Android toma las transiciones y el efecto táctil de iOS: las dos apps
      // tienen que verse y moverse igual en cualquier teléfono.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      splashFactory: InkRipple.splashFactory,
      scaffoldBackgroundColor: canvas,
      canvasColor: canvas,
      dividerColor: palette.outline,
      dividerTheme: DividerThemeData(color: palette.outline, space: 1),
      extensions: [palette],
      textTheme: buildTextTheme(ink, muted),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: ink,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          side: BorderSide(color: palette.outline),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: palette.surfaceMuted,
          disabledForegroundColor: palette.faint,
          elevation: 0,
          padding: buttonPadding,
          textStyle: buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: isDark
                ? BorderSide.none
                : const BorderSide(color: AppColors.primaryBorder),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          disabledBackgroundColor: palette.surfaceMuted,
          disabledForegroundColor: palette.faint,
          padding: buttonPadding,
          textStyle: buttonText,
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primaryStrong,
          side: BorderSide(color: palette.primaryStrong),
          padding: buttonPadding,
          textStyle: buttonText,
          shape: buttonShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primaryStrong,
          textStyle: buttonText,
          shape: buttonShape,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        hintStyle: TextStyle(
            fontFamily: AppTheme.fontFamily,
            package: 'splg_lib',
            color: palette.faint),
        labelStyle: TextStyle(
            fontFamily: AppTheme.fontFamily,
            package: 'splg_lib',
            color: palette.muted),
        border: outlineBorder,
        enabledBorder: outlineBorder,
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: palette.danger),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: palette.danger, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: palette.surfaceSunken,
        selectedColor: palette.primarySoft,
        side: BorderSide(color: palette.outline),
        labelStyle: TextStyle(
            fontFamily: AppTheme.fontFamily, package: 'splg_lib', color: ink),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.lg),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? palette.surfaceMuted : AppColors.tinta900,
        contentTextStyle: TextStyle(
          fontFamily: AppTheme.fontFamily,
          package: 'splg_lib',
          color: isDark ? AppColors.darkInk : AppColors.tinta50,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
      ),
      iconTheme: IconThemeData(color: ink),
      listTileTheme: ListTileThemeData(iconColor: palette.muted),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: palette.primarySoft,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : null,
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.onPrimary : null,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? scheme.primary : null,
        ),
      ),
    );
  }
}
