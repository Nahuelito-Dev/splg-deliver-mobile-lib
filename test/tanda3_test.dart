import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splg_lib/splg_lib.dart';

Widget _wrap(Widget child) =>
    MaterialApp(theme: AppTheme.lightTheme, home: Scaffold(body: child));

void main() {
  group('SplgPartyRow', () {
    testWidgets('muestra nombre, apoyo y la calificación con su cantidad',
        (t) async {
      await t.pumpWidget(_wrap(const SplgPartyRow(
          name: 'Emilia Villalba',
          subtitle: '+54 9 381 555',
          rating: 4.5,
          ratingCount: 12)));
      expect(find.text('Emilia Villalba'), findsOneWidget);
      expect(find.text('+54 9 381 555'), findsOneWidget);
      expect(find.text('4.5 (12)'), findsOneWidget);
      expect(find.byKey(const Key('party-no-rating')), findsNothing);
    });

    testWidgets('sin calificaciones dice "Sin calificaciones"', (t) async {
      await t.pumpWidget(
          _wrap(const SplgPartyRow(name: 'Ana', rating: 0, ratingCount: 0)));
      expect(find.byKey(const Key('party-no-rating')), findsOneWidget);
      expect(find.byKey(const Key('party-rating')), findsNothing);
    });
  });

  group('SplgActionButton', () {
    testWidgets('toca y dispara; con loading no responde', (t) async {
      var taps = 0;
      await t.pumpWidget(_wrap(
          SplgActionButton(title: 'Aceptar pedido', onPressed: () => taps++)));
      await t.tap(find.text('Aceptar pedido'));
      expect(taps, 1);

      await t.pumpWidget(_wrap(SplgActionButton(
          title: 'Aceptar pedido', loading: true, onPressed: () => taps++)));
      await t.tap(find.byKey(const Key('action-chip')));
      expect(taps, 1);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('sin onPressed está atenuado y no responde', (t) async {
      await t.pumpWidget(
          _wrap(const SplgActionButton(title: 'Salir', onPressed: null)));
      await t.tap(find.text('Salir'));
      final o = t.widget<Opacity>(find.byType(Opacity));
      expect(o.opacity, 0.5);
    });
  });

  group('SplgChoiceDialog', () {
    testWidgets('devuelve el valor de la opción tocada', (t) async {
      String? picked;
      await t.pumpWidget(MaterialApp(
        theme: AppTheme.lightTheme,
        home: Builder(
          builder: (ctx) => TextButton(
            onPressed: () async {
              picked = await showDialog<String>(
                context: ctx,
                builder: (_) => const SplgChoiceDialog<String>(
                  message: 'Al aceptar el pedido elegí un mapa:',
                  boldPrefix: 'aceptar',
                  choices: [
                    SplgChoice('stay', 'Permanecer en SPLG', bold: true),
                    SplgChoice('google', 'Ir a Google Maps'),
                    SplgChoice('waze', 'Ir a Waze'),
                  ],
                ),
              );
            },
            child: const Text('abrir'),
          ),
        ),
      ));
      await t.tap(find.text('abrir'));
      await t.pumpAndSettle();
      expect(find.text('Permanecer en SPLG'), findsOneWidget);
      expect(find.text('Ir a Waze'), findsOneWidget);
      await t.tap(find.text('Ir a Waze'));
      await t.pumpAndSettle();
      expect(picked, 'waze');
    });
  });

  group('SplgCountdownBar', () {
    testWidgets('proporción y texto; rojo en los últimos segundos', (t) async {
      await t
          .pumpWidget(_wrap(const SplgCountdownBar(remaining: 15, total: 30)));
      var bar = t.widget<LinearProgressIndicator>(
          find.byKey(const Key('countdown-bar')));
      expect(bar.value, 0.5);
      expect(find.text('La oferta vence en 15 s'), findsOneWidget);
      var color = (bar.valueColor! as AlwaysStoppedAnimation<Color>).value;

      await t
          .pumpWidget(_wrap(const SplgCountdownBar(remaining: 4, total: 30)));
      bar = t.widget<LinearProgressIndicator>(
          find.byKey(const Key('countdown-bar')));
      final warn = (bar.valueColor! as AlwaysStoppedAnimation<Color>).value;
      expect(warn, isNot(color));
    });

    testWidgets('no baja de 0 ni pasa de 1', (t) async {
      await t
          .pumpWidget(_wrap(const SplgCountdownBar(remaining: -3, total: 30)));
      expect(
          t
              .widget<LinearProgressIndicator>(
                  find.byKey(const Key('countdown-bar')))
              .value,
          0);
      expect(find.text('La oferta vence en 0 s'), findsOneWidget);
    });
  });

  group('SplgRouteRow y SplgEarnedBanner', () {
    testWidgets('fila con texto y apoyo', (t) async {
      await t.pumpWidget(_wrap(const SplgRouteRow(
          icon: SplgIcons.location,
          text: 'Buenos Aires 4114',
          caption: '08:00 a 12:00')));
      expect(find.text('Buenos Aires 4114'), findsOneWidget);
      expect(find.text('08:00 a 12:00'), findsOneWidget);
    });

    testWidgets('banner muestra el monto', (t) async {
      await t.pumpWidget(_wrap(const SplgEarnedBanner(amount: r'$14.900')));
      expect(find.text('¡Ganaste!'), findsOneWidget);
      expect(find.text(r'$14.900'), findsOneWidget);
    });
  });
}
