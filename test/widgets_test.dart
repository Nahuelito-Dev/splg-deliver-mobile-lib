import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splg_lib/splg_lib.dart';

Widget _wrap(Widget child, {ThemeData? theme}) => MaterialApp(
      theme: theme ?? AppTheme.lightTheme,
      home: Scaffold(body: child),
    );

void main() {
  group('SplgHeader', () {
    testWidgets('muestra el título y vuelve con la flecha', (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) =>
                    const Scaffold(appBar: SplgHeader(title: 'Mi perfil')),
              )),
              child: const Text('ir'),
            ),
          ),
        ),
      ));
      await tester.tap(find.text('ir'));
      await tester.pumpAndSettle();
      expect(find.text('Mi perfil'), findsOneWidget);
      await tester.tap(find.byTooltip('Volver'));
      await tester.pumpAndSettle();
      expect(find.text('Mi perfil'), findsNothing);
    });

    testWidgets('con centerTitle false el título queda pegado a la flecha',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(
            appBar: SplgHeader(title: 'Mi jornada', centerTitle: false)),
      ));
      final back = tester.getTopRight(find.byTooltip('Volver'));
      final title = tester.getTopLeft(find.text('Mi jornada'));
      expect(title.dx - back.dx, lessThanOrEqualTo(12));
    });

    testWidgets('sin flecha si showBack es false', (tester) async {
      await tester.pumpWidget(_wrap(const SizedBox()));
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: const Scaffold(appBar: SplgHeader(title: 'X', showBack: false)),
      ));
      expect(find.byTooltip('Volver'), findsNothing);
    });
  });

  group('SplgMenuItem', () {
    testWidgets('dispara onTap y muestra chevron', (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(SplgMenuItem(
          label: 'Mis entregas', icon: Icons.list, onTap: () => taps++)));
      expect(find.byIcon(SplgIcons.next), findsOneWidget);
      await tester.tap(find.text('Mis entregas'));
      expect(taps, 1);
    });

    testWidgets('destructivo no muestra chevron', (tester) async {
      await tester.pumpWidget(_wrap(SplgMenuItem(
          label: 'Cerrar sesión', destructive: true, onTap: () {})));
      expect(find.byIcon(SplgIcons.next), findsNothing);
    });
  });

  testWidgets('SplgEmptyState muestra título y mensaje', (tester) async {
    await tester.pumpWidget(_wrap(const SplgEmptyState(message: 'Sin datos')));
    expect(find.text('¡Nada por aquí!'), findsOneWidget);
    expect(find.text('Sin datos'), findsOneWidget);
  });

  testWidgets('SplgAccordion abre de a uno', (tester) async {
    await tester.pumpWidget(_wrap(const SplgAccordion(entries: [
      SplgAccordionEntry(title: 'A', body: 'cuerpo A'),
      SplgAccordionEntry(title: 'B', body: 'cuerpo B'),
    ])));
    expect(find.text('cuerpo A'), findsNothing);
    await tester.tap(find.text('A'));
    await tester.pump();
    expect(find.text('cuerpo A'), findsOneWidget);
    await tester.tap(find.text('B'));
    await tester.pump();
    expect(find.text('cuerpo A'), findsNothing);
    expect(find.text('cuerpo B'), findsOneWidget);
    await tester.tap(find.text('B'));
    await tester.pump();
    expect(find.text('cuerpo B'), findsNothing);
  });

  group('SplgPasswordField', () {
    testWidgets('alterna la visibilidad', (tester) async {
      final c = TextEditingController(text: 'secreto');
      await tester
          .pumpWidget(_wrap(SplgPasswordField(label: 'Clave', controller: c)));
      expect(
          tester.widget<TextField>(find.byType(TextField)).obscureText, isTrue);
      await tester.tap(find.byTooltip('Mostrar contraseña'));
      await tester.pump();
      expect(tester.widget<TextField>(find.byType(TextField)).obscureText,
          isFalse);
    });

    testWidgets('inválido muestra el error en rojo; válido el tilde',
        (tester) async {
      final c = TextEditingController();
      await tester.pumpWidget(_wrap(SplgPasswordField(
          label: 'Clave',
          controller: c,
          status: SplgFieldStatus.invalid,
          errorText: 'No coinciden')));
      expect(find.text('No coinciden'), findsOneWidget);
      expect(find.byIcon(SplgIcons.error), findsOneWidget);
      await tester.pumpWidget(_wrap(SplgPasswordField(
          label: 'Clave', controller: c, status: SplgFieldStatus.valid)));
      expect(find.byIcon(SplgIcons.ok), findsOneWidget);
      expect(find.text('No coinciden'), findsNothing);
    });
  });

  testWidgets('SplgDarkCard usa la superficie inversa del tema',
      (tester) async {
    await tester.pumpWidget(_wrap(const SplgDarkCard(child: Text('Hoy'))));
    final material = tester.widget<Material>(find.descendant(
        of: find.byType(SplgDarkCard), matching: find.byType(Material)));
    expect(material.color, AppTheme.lightTheme.colorScheme.inverseSurface);
  });

  group('Tipografía Geist', () {
    for (final entry in {
      'claro': AppTheme.lightTheme,
      'oscuro': AppTheme.darkTheme,
    }.entries) {
      test('${entry.key}: el textTheme usa Geist de splg_lib', () {
        final t = entry.value.textTheme;
        for (final style in [t.bodyMedium, t.titleLarge, t.labelMedium]) {
          expect(style!.fontFamily, 'packages/splg_lib/Geist');
        }
      });
    }
  });
}
