import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splg_lib/splg_lib.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      home: Scaffold(
          body: Padding(padding: const EdgeInsets.all(16), child: child)),
    );

double _lum(Color c) {
  double ch(double v) =>
      v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
  return 0.2126 * ch(c.r) + 0.7152 * ch(c.g) + 0.0722 * ch(c.b);
}

double _contrast(Color a, Color b) {
  final la = _lum(a), lb = _lum(b);
  return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
}

TextField _field(WidgetTester t) => t.widget<TextField>(find.byType(TextField));

void main() {
  group('contraste de campos (WCAG)', () {
    test('borde en reposo >= 3:1 contra superficie y fondo, claro y oscuro',
        () {
      expect(_contrast(BrasaPalette.light.outlineStrong, AppColors.surface),
          greaterThanOrEqualTo(3));
      expect(_contrast(BrasaPalette.light.outlineStrong, AppColors.canvas),
          greaterThanOrEqualTo(3));
      expect(_contrast(BrasaPalette.dark.outlineStrong, AppColors.darkSurface),
          greaterThanOrEqualTo(3));
      expect(_contrast(BrasaPalette.dark.outlineStrong, AppColors.darkCanvas),
          greaterThanOrEqualTo(3));
    });

    test('el texto apagado (placeholder) >= 4,5:1', () {
      expect(_contrast(BrasaPalette.light.muted, AppColors.surface),
          greaterThanOrEqualTo(4.5));
      expect(_contrast(BrasaPalette.light.muted, AppColors.canvas),
          greaterThanOrEqualTo(4.5));
      expect(_contrast(BrasaPalette.dark.muted, AppColors.darkSurface),
          greaterThanOrEqualTo(4.5));
    });
  });

  group('SplgTextField', () {
    testWidgets('el borde en reposo usa outlineStrong y el foco la marca',
        (t) async {
      await t.pumpWidget(_wrap(
          SplgTextField(controller: TextEditingController(), hint: 'Nombre')));
      final deco = _field(t).decoration!;
      expect((deco.enabledBorder as OutlineInputBorder).borderSide.color,
          BrasaPalette.light.outlineStrong);
      final focused = (deco.focusedBorder as OutlineInputBorder).borderSide;
      expect(focused.color, AppTheme.lightTheme.colorScheme.primary);
      expect(
          focused.width,
          greaterThan(
              (deco.enabledBorder as OutlineInputBorder).borderSide.width));
      expect(deco.hintStyle!.color, BrasaPalette.light.muted);
    });

    testWidgets('por defecto es de una línea', (t) async {
      await t.pumpWidget(
          _wrap(SplgTextField(controller: TextEditingController())));
      expect(_field(t).maxLines, 1);
      expect(_field(t).minLines, isNull);
    });

    testWidgets('minLines sin maxLines no rompe y es multilínea', (t) async {
      await t.pumpWidget(_wrap(
          SplgTextField(controller: TextEditingController(), minLines: 3)));
      expect(t.takeException(), isNull);
      expect(_field(t).minLines, 3);
      expect(_field(t).maxLines, 3);
      expect(_field(t).keyboardType, TextInputType.multiline);
    });

    testWidgets('maxLines menor que minLines se sube a minLines', (t) async {
      await t.pumpWidget(_wrap(SplgTextField(
          controller: TextEditingController(), minLines: 4, maxLines: 2)));
      expect(t.takeException(), isNull);
      expect(_field(t).maxLines, 4);
    });

    testWidgets('maxLines solo es multilínea con minLines 1', (t) async {
      await t.pumpWidget(_wrap(
          SplgTextField(controller: TextEditingController(), maxLines: 5)));
      expect(_field(t).minLines, 1);
      expect(_field(t).maxLines, 5);
    });

    testWidgets('obscure nunca es multilínea', (t) async {
      await t.pumpWidget(_wrap(SplgTextField(
          controller: TextEditingController(),
          obscure: true,
          minLines: 3,
          maxLines: 5)));
      expect(t.takeException(), isNull);
      expect(_field(t).maxLines, 1);
      expect(_field(t).minLines, isNull);
    });
  });

  group('SplgType', () {
    testWidgets('fieldLabel va en tinta secundaria; action en marca',
        (t) async {
      late SplgType type;
      await t.pumpWidget(_wrap(Builder(builder: (c) {
        type = SplgType.of(c);
        return const SizedBox();
      })));
      expect(type.fieldLabel.color, BrasaPalette.light.ink2);
      expect(type.action.color, BrasaPalette.light.primaryStrong);
      expect(type.title.color, AppColors.tinta900);
      expect(type.captionStrong.color, BrasaPalette.light.ink2);
    });

    testWidgets('las etiquetas del campo de contraseña usan fieldLabel',
        (t) async {
      late SplgType type;
      await t.pumpWidget(_wrap(Builder(builder: (c) {
        type = SplgType.of(c);
        return SplgPasswordField(
            label: 'Clave', controller: TextEditingController());
      })));
      final label = t.widget<Text>(find.text('Clave'));
      expect(label.style!.color, type.fieldLabel.color);
      expect(label.style!.fontWeight, type.fieldLabel.fontWeight);
    });
  });

  group('SplgCheckboxLink', () {
    testWidgets('con onLink se ve como enlace de marca subrayado', (t) async {
      await t.pumpWidget(_wrap(SplgCheckboxLink(
          label: 'Aceptar Términos',
          value: false,
          onChanged: (_) {},
          onLink: () {})));
      final s = t.widget<Text>(find.text('Aceptar Términos')).style!;
      expect(s.color, BrasaPalette.light.primaryStrong);
      expect(s.decoration, TextDecoration.underline);
    });
  });

  testWidgets('SplgInfoRow sin dato usa un gris legible', (t) async {
    await t.pumpWidget(_wrap(const SplgInfoRow(title: 'Patente', value: null)));
    expect(t.widget<Text>(find.text('Sin datos')).style!.color,
        BrasaPalette.light.muted);
  });
}
