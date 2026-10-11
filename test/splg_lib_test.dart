import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splg_lib/splg_lib.dart';

double _lum(Color c) {
  double ch(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
}

/// Contraste WCAG 2.1 entre dos colores opacos.
double contrast(Color a, Color b) {
  final la = _lum(a), lb = _lum(b);
  final hi = math.max(la, lb), lo = math.min(la, lb);
  return (hi + 0.05) / (lo + 0.05);
}

void contrastTests() {
  group('Contraste AA (4,5:1)', () {
    for (final entry in {
      'claro': AppTheme.lightTheme,
      'oscuro': AppTheme.darkTheme,
    }.entries) {
      final t = entry.value;
      final b = t.extension<BrasaPalette>()!;
      final s = t.colorScheme;
      test('${entry.key}: botón principal y texto de marca', () {
        expect(contrast(s.onPrimary, s.primary), greaterThanOrEqualTo(4.5));
        expect(contrast(s.primary, s.surface), greaterThanOrEqualTo(4.5));
        expect(contrast(s.primary, t.scaffoldBackgroundColor),
            greaterThanOrEqualTo(4.5));
        expect(contrast(b.primaryStrong, s.surface), greaterThanOrEqualTo(4.5));
      });
      test('${entry.key}: textos y estados', () {
        expect(contrast(s.onSurface, s.surface), greaterThanOrEqualTo(4.5));
        expect(contrast(b.muted, s.surface), greaterThanOrEqualTo(4.5));
        for (final (fg, bg) in [
          (b.success, b.successSoft),
          (b.warn, b.warnSoft),
          (b.danger, b.dangerSoft),
          (b.info, b.infoSoft),
          (b.success, s.surface),
          (b.warn, s.surface),
          (b.danger, s.surface),
        ]) {
          expect(contrast(fg, bg), greaterThanOrEqualTo(4.5),
              reason: '$fg sobre $bg');
        }
      });
    }
  });
}

void main() {
  labelTests();
  contrastTests();
  group('AppTheme (Brasa)', () {
    test('claro: primario llama, canvas y superficie de brand.json', () {
      final t = AppTheme.lightTheme;
      expect(t.colorScheme.primary, const Color(0xFFC2470C));
      expect(t.scaffoldBackgroundColor, const Color(0xFFF5F6F8));
      expect(t.colorScheme.surface, const Color(0xFFFFFFFF));
      expect(t.colorScheme.onSurface, const Color(0xFF0B1220));
      expect(t.colorScheme.error, const Color(0xFFB42318));
    });

    test('oscuro: canvas, superficie y estados del bloque dark', () {
      final t = AppTheme.darkTheme;
      expect(t.brightness, Brightness.dark);
      expect(t.scaffoldBackgroundColor, const Color(0xFF0B0F16));
      expect(t.colorScheme.primary, const Color(0xFFFF9A52));
      expect(t.colorScheme.surface, const Color(0xFF131A25));
      expect(t.colorScheme.onSurface, const Color(0xFFF3F4F6));
      expect(t.colorScheme.error, const Color(0xFFF2706A));
    });

    test('la extensión trae estados con su fondo suave en ambos modos', () {
      final l = AppTheme.lightTheme.extension<BrasaPalette>()!;
      final d = AppTheme.darkTheme.extension<BrasaPalette>()!;
      expect(l.success, const Color(0xFF067647));
      expect(l.successSoft, const Color(0xFFECFDF3));
      expect(l.warn, const Color(0xFFB54708));
      expect(l.info, const Color(0xFF175CD3));
      expect(d.success, const Color(0xFF3DBD82));
      expect(d.dangerSoft, const Color(0xFF2E1212));
      expect(d.primaryStrong, const Color(0xFFFF9A52));
    });

    test(
        'el botón principal usa el primario del esquema y el radio del sistema',
        () {
      final style = AppTheme.lightTheme.elevatedButtonTheme.style!;
      expect(style.backgroundColor!.resolve({}), AppColors.primary);
      final dark = AppTheme.darkTheme.elevatedButtonTheme.style!;
      expect(dark.backgroundColor!.resolve({}), const Color(0xFFFF9A52));
      final shape = style.shape!.resolve({}) as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(AppRadii.md));
    });

    test('el primario es el punto medio del degradé del panel', () {
      final mid = Color.lerp(
        AppColors.primaryGradientFrom,
        AppColors.primaryGradientTo,
        0.5,
      )!;
      expect(AppColors.primary.toARGB32(), mid.toARGB32());
    });
  });

  group('SplgLogo', () {
    testWidgets('dibuja la llama y el wordmark SPLG', (tester) async {
      await tester.pumpWidget(
        MaterialApp(theme: AppTheme.lightTheme, home: const SplgLogo()),
      );
      expect(find.text('SPLG'), findsOneWidget);
      expect(find.bySemanticsLabel('SPLG'), findsOneWidget);
    });

    test('la llama entra en el cuadro', () {
      final b = splgFlamePath(const Size(24, 24)).getBounds();
      expect(b.left, greaterThanOrEqualTo(0));
      expect(b.right, lessThanOrEqualTo(24));
      expect(b.top, greaterThanOrEqualTo(0));
      expect(b.bottom, lessThanOrEqualTo(24));
    });
  });
}

GasCylinder _cyl(String type) => GasCylinder(
      id: 'x',
      type: type,
      price: 1,
      active: true,
      weight: '10',
      description: '',
    );

void labelTests() {
  group('GasCylinderLabel', () {
    test('no repite "Garrafa" si el tipo ya lo trae', () {
      expect(_cyl('Garrafa 10kg').label, 'Garrafa 10kg');
    });
    test('lo antepone cuando el tipo es sólo la medida', () {
      expect(_cyl('10kg').label, 'Garrafa 10kg');
    });
  });
}
