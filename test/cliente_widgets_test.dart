import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splg_lib/splg_lib.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );

double _luminanceContrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  final hi = la > lb ? la : lb, lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  testWidgets('SplgIconButton responde al toque y tiene tooltip',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(_wrap(SplgIconButton(
        icon: SplgIcons.menu, tooltip: 'Menú', onPressed: () => taps++)));
    await tester.tap(find.byTooltip('Menú'));
    expect(taps, 1);
  });

  testWidgets('SplgBottomPanel muestra el asa y el contenido', (tester) async {
    await tester.pumpWidget(_wrap(const SplgBottomPanel(child: Text('Hola'))));
    expect(find.byKey(const Key('panel-handle')), findsOneWidget);
    expect(find.text('Hola'), findsOneWidget);
  });

  testWidgets('SplgAddressPill: quitar y tocar', (tester) async {
    var cleared = 0, taps = 0;
    await tester.pumpWidget(_wrap(SplgAddressPill(
        text: 'Mitre 123', onTap: () => taps++, onClear: () => cleared++)));
    await tester.tap(find.text('Mitre 123'));
    await tester.tap(find.byTooltip('Quitar'));
    expect((taps, cleared), (1, 1));
  });

  testWidgets('SplgAddressPill sin onClear no muestra la ×', (tester) async {
    await tester.pumpWidget(_wrap(const SplgAddressPill(text: 'X')));
    expect(find.byTooltip('Quitar'), findsNothing);
  });

  testWidgets('SplgOptionRow muestra título y valor y dispara onTap',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(_wrap(SplgOptionRow(
        icon: SplgIcons.cash,
        title: 'Forma de pago',
        value: 'Efectivo',
        onTap: () => taps++)));
    expect(find.text('Efectivo'), findsOneWidget);
    await tester.tap(find.text('Forma de pago'));
    expect(taps, 1);
  });

  testWidgets('SplgRadioRow: elegido, deshabilitado', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_wrap(Column(children: [
      SplgRadioRow(title: 'A', selected: true, onTap: () => taps++),
      const SplgRadioRow(title: 'B', selected: false, onTap: null),
    ])));
    expect(find.byIcon(SplgIcons.radioOn), findsOneWidget);
    expect(find.byIcon(SplgIcons.radioOff), findsOneWidget);
    await tester.tap(find.text('A'));
    await tester.tap(find.text('B'));
    expect(taps, 1);
  });

  testWidgets('SplgStatusBadge cumple contraste AA en claro y oscuro',
      (tester) async {
    for (final theme in [AppTheme.lightTheme, AppTheme.darkTheme]) {
      late BrasaPalette b;
      await tester.pumpWidget(MaterialApp(
          theme: theme,
          home: Builder(builder: (c) {
            b = c.brasa;
            return Column(children: [
              for (final t in SplgTone.values)
                SplgStatusBadge(label: t.name, tone: t),
            ]);
          })));
      for (final t in SplgTone.values) {
        expect(find.text(t.name), findsOneWidget);
      }
      expect(_luminanceContrast(b.success, b.successSoft), greaterThan(3));
      expect(_luminanceContrast(b.danger, b.dangerSoft), greaterThan(3));
    }
  });

  testWidgets('SplgOrderCard: título, insignia, detalle y toque',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(_wrap(SplgOrderCard(
        title: 'Mitre 123',
        subtitle: '10/10/2026',
        detail: 'Total: \$1.500',
        badge: 'ENTREGADO',
        badgeTone: SplgTone.success,
        onTap: () => taps++)));
    expect(find.text('ENTREGADO'), findsOneWidget);
    expect(find.text('Total: \$1.500'), findsOneWidget);
    await tester.tap(find.text('Mitre 123'));
    expect(taps, 1);
  });

  testWidgets('showSplgDialog devuelve true / false', (tester) async {
    bool? result;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: Builder(
        builder: (c) => TextButton(
          onPressed: () async => result = await showSplgDialog(c,
              title: 'T',
              message: 'M',
              primaryLabel: 'Sí',
              secondaryLabel: 'No'),
          child: const Text('abrir'),
        ),
      ),
    ));
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    expect(find.text('M'), findsOneWidget);
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();
    expect(result, false);
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sí'));
    await tester.pumpAndSettle();
    expect(result, true);
  });

  testWidgets('SplgButton ghost: texto blanco y toque', (tester) async {
    var taps = 0;
    await tester.pumpWidget(MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SplgButton(
            title: 'Cancelar',
            style: SplgButtonStyle.ghost,
            onPressed: () => taps++),
      ),
    ));
    final text = tester.widget<Text>(find.text('Cancelar'));
    expect(text.style?.color, Colors.white);
    await tester.tap(find.text('Cancelar'));
    expect(taps, 1);
  });

  testWidgets('SplgLoader', (tester) async {
    await tester
        .pumpWidget(_wrap(const SizedBox(height: 50, child: SplgLoader())));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('SplgCheckboxLink: casilla y enlace', (tester) async {
    var v = false, link = 0;
    await tester.pumpWidget(StatefulBuilder(
      builder: (c, set) => _wrap(SplgCheckboxLink(
          label: 'Aceptar Términos',
          value: v,
          onChanged: (x) => set(() => v = x),
          onLink: () => link++)),
    ));
    await tester.tap(find.byIcon(SplgIcons.checkOff));
    await tester.pump();
    expect(v, true);
    await tester.tap(find.text('Aceptar Términos'));
    expect(link, 1);
    expect(v, true);
  });

  testWidgets('SplgStepDots marca el actual', (tester) async {
    await tester.pumpWidget(_wrap(const SplgStepDots(count: 3, current: 1)));
    expect(find.byKey(const Key('dot-2')), findsOneWidget);
    expect(find.bySemanticsLabel('Paso 2 de 3'), findsOneWidget);
  });

  testWidgets('SplgIllustrationHeader dibuja la ilustración', (tester) async {
    await tester.pumpWidget(_wrap(
        const SplgIllustrationHeader(illustration: SplgIllustration.success)));
    expect(find.byType(Image), findsOneWidget);
  });

  group('SplgPhoneField', () {
    test('toE164 normaliza', () {
      expect(SplgPhoneField.toE164('(+54) 11 5555-1234'), '+541155551234');
      expect(SplgPhoneField.toE164('5411 5555 1234'), '+541155551234');
      expect(SplgPhoneField.toE164('11 5555 1234'), '+541155551234');
    });
    test('isValid', () {
      expect(SplgPhoneField.isValid('1155551234'), true);
      expect(SplgPhoneField.isValid('123'), false);
    });
    testWidgets('filtra letras y muestra +54', (tester) async {
      final c = TextEditingController();
      await tester.pumpWidget(_wrap(SplgPhoneField(controller: c)));
      await tester.enterText(find.byType(TextField), 'ab12cd3');
      expect(c.text, '123');
      expect(find.text('+54'), findsOneWidget);
    });
  });

  testWidgets('SplgTextArea cuenta caracteres y limita', (tester) async {
    final c = TextEditingController();
    await tester.pumpWidget(_wrap(SplgTextArea(controller: c, maxLength: 10)));
    expect(find.text('0/10'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'hola');
    await tester.pump();
    expect(find.text('4/10'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '12345678901234');
    await tester.pump();
    expect(c.text.length, 10);
  });

  testWidgets('SplgRatingInput elige estrellas', (tester) async {
    var v = 0;
    await tester.pumpWidget(StatefulBuilder(
      builder: (c, set) =>
          _wrap(SplgRatingInput(value: v, onChanged: (x) => set(() => v = x))),
    ));
    await tester.tap(find.byTooltip('4 estrellas'));
    await tester.pump();
    expect(v, 4);
    expect(find.byIcon(SplgIcons.star), findsNWidgets(4));
  });

  testWidgets('SplgProfileHeader: nombre, teléfono y enlace', (tester) async {
    var taps = 0;
    await tester.pumpWidget(_wrap(SplgProfileHeader(
        name: 'Ana Pérez',
        phone: '+5411',
        initials: 'AP',
        linkLabel: 'Editar perfil',
        onLink: () => taps++)));
    expect(find.text('Ana Pérez'), findsOneWidget);
    await tester.tap(find.text('Editar perfil'));
    expect(taps, 1);
  });

  testWidgets('SplgProductCard y SplgQuantityStepper', (tester) async {
    var q = 1, add = 0, rem = 0;
    await tester.pumpWidget(_wrap(SplgProductCard(
        image: const SizedBox(),
        title: 'Garrafa 10kg',
        price: '\$5.000',
        quantity: q,
        promos: const ['−10% x4'],
        onAdd: () => add++,
        onRemove: () => rem++)));
    expect(find.text('−10% x4'), findsOneWidget);
    await tester.tap(find.byTooltip('Agregar uno'));
    await tester.tap(find.byTooltip('Quitar uno'));
    expect((add, rem), (1, 1));
  });

  testWidgets('SplgQuantityStepper en 0 no deja quitar', (tester) async {
    var rem = 0;
    await tester.pumpWidget(_wrap(
        SplgQuantityStepper(quantity: 0, onAdd: () {}, onRemove: () => rem++)));
    await tester.tap(find.byTooltip('Quitar uno'));
    expect(rem, 0);
  });

  testWidgets('las ilustraciones nuevas existen como asset', (tester) async {
    await tester.pumpWidget(_wrap(Column(children: [
      for (final i in [
        SplgIllustration.location,
        SplgIllustration.calendar,
        SplgIllustration.support,
        SplgIllustration.noNetwork,
        SplgIllustration.claim,
      ])
        i.image(height: 20),
    ])));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
