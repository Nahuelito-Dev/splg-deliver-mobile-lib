import 'dart:ui';

/// Tokens del sistema visual Brasa. Espejo de
/// `splg-app-admin/src/theme/brand.json`: si cambia allá, cambia acá.
class AppColors {
  AppColors._();

  // llama (marca)
  static const Color llama50 = Color(0xFFFFF5ED);
  static const Color llama100 = Color(0xFFFFE6D3);
  static const Color llama200 = Color(0xFFFFCCA8);
  static const Color llama300 = Color(0xFFFFB27A);
  static const Color llama400 = Color(0xFFFF8A3D);
  static const Color llama500 = Color(0xFFF26B1D);
  static const Color llama600 = Color(0xFFD9530E);
  static const Color llama700 = Color(0xFFB8430B);
  static const Color llama800 = Color(0xFF93360C);
  static const Color llama900 = Color(0xFF772E0E);

  // gas (acento)
  static const Color gas50 = Color(0xFFFFFAEB);
  static const Color gas100 = Color(0xFFFEF0C7);
  static const Color gas200 = Color(0xFFFEDF89);
  static const Color gas300 = Color(0xFFFEC84B);
  static const Color gas400 = Color(0xFFFFB020);
  static const Color gas500 = Color(0xFFF79009);
  static const Color gas600 = Color(0xFFDC6803);
  static const Color gas700 = Color(0xFFB54708);
  static const Color gas800 = Color(0xFF93370D);
  static const Color gas900 = Color(0xFF7A2E0E);

  // tinta (neutro)
  static const Color tinta25 = Color(0xFFFAFBFC);
  static const Color tinta50 = Color(0xFFF5F6F8);
  static const Color tinta100 = Color(0xFFF0F2F5);
  static const Color tinta200 = Color(0xFFE7EAEE);
  static const Color tinta300 = Color(0xFFD0D5DD);
  static const Color tinta400 = Color(0xFF98A2B3);
  static const Color tinta500 = Color(0xFF667085);
  static const Color tinta600 = Color(0xFF475467);
  static const Color tinta700 = Color(0xFF344054);
  static const Color tinta800 = Color(0xFF1D2939);
  static const Color tinta900 = Color(0xFF0B1220);
  static const Color tinta950 = Color(0xFF0B0F16);

  static const Color canvas = Color(0xFFF5F6F8);
  static const Color surface = Color(0xFFFFFFFF);

  // estados (claro)
  static const Color success = Color(0xFF067647);
  static const Color danger = Color(0xFFB42318);
  static const Color warn = Color(0xFFB54708);
  static const Color info = Color(0xFF175CD3);
  static const Color successSoft = Color(0xFFECFDF3);
  static const Color dangerSoft = Color(0xFFFEF3F2);
  static const Color warnSoft = Color(0xFFFFFAEB);
  static const Color infoSoft = Color(0xFFEFF8FF);

  // botón principal: degradé del panel. En Flutter el botón es plano y usa
  // el punto medio ([primary]), donde el texto blanco mide 5,03 (AA).
  static const Color primaryGradientFrom = Color(0xFFD24E0D);
  static const Color primaryGradientTo = Color(0xFFB23F0A);
  static const Color primaryBorder = Color(0xFFA13A09);
  static const Color primary = Color(0xFFC2470C);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // oscuro
  static const Color darkCanvas = Color(0xFF0B0F16);
  static const Color darkSurface = Color(0xFF131A25);
  static const Color darkSurfaceHover = Color(0xFF1B2330);
  static const Color darkSurfaceSunken = Color(0xFF171E29);
  static const Color darkSurfaceMuted = Color(0xFF212A38);
  static const Color darkInk = Color(0xFFF3F4F6);
  static const Color darkInk2 = Color(0xFFC7CCD4);
  static const Color darkMuted = Color(0xFF8B93A3);
  static const Color darkFaint = Color(0xFF67707F);
  static const Color darkOutline = Color(0xFF2E3847);
  static const Color darkOutlineSoft = Color(0xFF202836);
  static const Color darkPrimarySoft = Color(0xFF2A180F);
  static const Color darkPrimaryStrong = Color(0xFFFF9A52);
  static const Color darkAccentSoft = Color(0xFF2E2308);
  static const Color darkOnAccent = Color(0xFFFFE6B8);
  static const Color darkSuccess = Color(0xFF3DBD82);
  static const Color darkDanger = Color(0xFFF2706A);
  static const Color darkWarn = Color(0xFFF2B84B);
  static const Color darkInfo = Color(0xFF5B9DF2);
  static const Color darkSuccessSoft = Color(0xFF0F2A1E);
  static const Color darkDangerSoft = Color(0xFF2E1212);
  static const Color darkWarnSoft = Color(0xFF2E2210);
  static const Color darkInfoSoft = Color(0xFF11233B);
}

/// Radios del sistema (el panel usa 10 y 8 en tooltips).
class AppRadii {
  AppRadii._();

  static const double sm = 8;
  static const double md = 10;
  static const double lg = 14;
}
