import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Colores de Brasa que `ColorScheme` no cubre: estados con su fondo suave,
/// acento y neutros secundarios. Se lee con `context.brasa`.
@immutable
class BrasaPalette extends ThemeExtension<BrasaPalette> {
  const BrasaPalette({
    required this.primaryStrong,
    required this.primarySoft,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.success,
    required this.successSoft,
    required this.warn,
    required this.warnSoft,
    required this.danger,
    required this.dangerSoft,
    required this.info,
    required this.infoSoft,
    required this.ink2,
    required this.muted,
    required this.faint,
    required this.outline,
    required this.outlineSoft,
    required this.outlineStrong,
    required this.surfaceSunken,
    required this.surfaceMuted,
  });

  final Color primaryStrong;
  final Color primarySoft;
  final Color accent;
  final Color onAccent;
  final Color accentSoft;
  final Color success;
  final Color successSoft;
  final Color warn;
  final Color warnSoft;
  final Color danger;
  final Color dangerSoft;
  final Color info;
  final Color infoSoft;
  final Color ink2;
  final Color muted;
  final Color faint;
  final Color outline;
  final Color outlineSoft;

  /// Borde de los campos de entrada en reposo: >= 3:1 contra la superficie y
  /// el fondo (WCAG 1.4.11).
  final Color outlineStrong;
  final Color surfaceSunken;
  final Color surfaceMuted;

  static const BrasaPalette light = BrasaPalette(
    primaryStrong: AppColors.llama700,
    primarySoft: AppColors.llama50,
    accent: AppColors.gas400,
    onAccent: AppColors.gas900,
    accentSoft: AppColors.gas50,
    success: AppColors.success,
    successSoft: AppColors.successSoft,
    warn: AppColors.warn,
    warnSoft: AppColors.warnSoft,
    danger: AppColors.danger,
    dangerSoft: AppColors.dangerSoft,
    info: AppColors.info,
    infoSoft: AppColors.infoSoft,
    ink2: AppColors.tinta700,
    muted: AppColors.tinta500,
    faint: AppColors.tinta400,
    outline: AppColors.tinta200,
    outlineSoft: AppColors.tinta100,
    outlineStrong: AppColors.tinta500,
    surfaceSunken: AppColors.tinta50,
    surfaceMuted: AppColors.tinta100,
  );

  static const BrasaPalette dark = BrasaPalette(
    primaryStrong: AppColors.darkPrimaryStrong,
    primarySoft: AppColors.darkPrimarySoft,
    accent: AppColors.gas400,
    onAccent: AppColors.darkOnAccent,
    accentSoft: AppColors.darkAccentSoft,
    success: AppColors.darkSuccess,
    successSoft: AppColors.darkSuccessSoft,
    warn: AppColors.darkWarn,
    warnSoft: AppColors.darkWarnSoft,
    danger: AppColors.darkDanger,
    dangerSoft: AppColors.darkDangerSoft,
    info: AppColors.darkInfo,
    infoSoft: AppColors.darkInfoSoft,
    ink2: AppColors.darkInk2,
    muted: AppColors.darkMuted,
    faint: AppColors.darkFaint,
    outline: AppColors.darkOutline,
    outlineSoft: AppColors.darkOutlineSoft,
    outlineStrong: AppColors.darkFaint,
    surfaceSunken: AppColors.darkSurfaceSunken,
    surfaceMuted: AppColors.darkSurfaceMuted,
  );

  @override
  BrasaPalette copyWith() => this;

  @override
  BrasaPalette lerp(ThemeExtension<BrasaPalette>? other, double t) {
    if (other is! BrasaPalette) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return BrasaPalette(
      primaryStrong: l(primaryStrong, other.primaryStrong),
      primarySoft: l(primarySoft, other.primarySoft),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      accentSoft: l(accentSoft, other.accentSoft),
      success: l(success, other.success),
      successSoft: l(successSoft, other.successSoft),
      warn: l(warn, other.warn),
      warnSoft: l(warnSoft, other.warnSoft),
      danger: l(danger, other.danger),
      dangerSoft: l(dangerSoft, other.dangerSoft),
      info: l(info, other.info),
      infoSoft: l(infoSoft, other.infoSoft),
      ink2: l(ink2, other.ink2),
      muted: l(muted, other.muted),
      faint: l(faint, other.faint),
      outline: l(outline, other.outline),
      outlineSoft: l(outlineSoft, other.outlineSoft),
      outlineStrong: l(outlineStrong, other.outlineStrong),
      surfaceSunken: l(surfaceSunken, other.surfaceSunken),
      surfaceMuted: l(surfaceMuted, other.surfaceMuted),
    );
  }
}

extension BrasaContext on BuildContext {
  /// Paleta Brasa del tema activo (claro u oscuro).
  BrasaPalette get brasa =>
      Theme.of(this).extension<BrasaPalette>() ?? BrasaPalette.light;
}
