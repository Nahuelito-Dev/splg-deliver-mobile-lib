import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splg_lib/splg_lib.dart';

Widget _wrap(Widget child) =>
    MaterialApp(theme: AppTheme.lightTheme, home: Scaffold(body: child));

TextStyle? _styleOf(WidgetTester tester, Finder button, String text) {
  final rich = find.descendant(of: button, matching: find.text(text));
  return DefaultTextStyle.of(tester.element(rich)).style;
}

void main() {
  group('Botones del tema usan Geist', () {
    testWidgets('los cuatro tipos renderizan con packages/splg_lib/Geist',
        (tester) async {
      await tester.pumpWidget(_wrap(Column(children: [
        ElevatedButton(onPressed: () {}, child: const Text('elevado')),
        FilledButton(onPressed: () {}, child: const Text('relleno')),
        OutlinedButton(onPressed: () {}, child: const Text('contorno')),
        TextButton(onPressed: () {}, child: const Text('texto')),
      ])));
      for (final (type, label) in [
        (ElevatedButton, 'elevado'),
        (FilledButton, 'relleno'),
        (OutlinedButton, 'contorno'),
        (TextButton, 'texto'),
      ]) {
        final style = _styleOf(tester, find.byType(type), label);
        expect(style?.fontFamily, 'packages/splg_lib/Geist', reason: '$type');
      }
    });

    testWidgets('SplgButton también', (tester) async {
      await tester
          .pumpWidget(_wrap(SplgButton(title: 'Confirmar', onPressed: () {})));
      final text = tester.widget<Text>(find.text('Confirmar'));
      final resolved =
          DefaultTextStyle.of(tester.element(find.text('Confirmar')))
              .style
              .merge(text.style);
      expect(resolved.fontFamily, 'packages/splg_lib/Geist');
    });
  });

  testWidgets('los chips usan Geist (no la fuente del sistema)',
      (tester) async {
    await tester.pumpWidget(_wrap(SplgChoiceChips(
        labels: const ['Hoy'], selected: 0, onSelected: (_) {})));
    final style = DefaultTextStyle.of(tester.element(find.text('Hoy'))).style;
    expect(style.fontFamily, 'packages/splg_lib/Geist');
  });

  testWidgets('SplgBarChartCard sin datos rotula el eje en 0', (tester) async {
    await tester.pumpWidget(_wrap(const SplgBarChartCard(
      title: 'Ganancia semanal',
      subtitle: '1 al 7',
      values: [0, 0, 0],
      labels: ['L', 'M', 'M'],
    )));
    expect(find.text('1'), findsNothing);
    expect(find.text('0'), findsWidgets);
  });

  group('SplgButton', () {
    testWidgets('sin onPressed no responde; cargando muestra el indicador',
        (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(Column(children: [
        const SplgButton(title: 'Apagado', onPressed: null),
        SplgButton(title: 'Cargando', loading: true, onPressed: () => taps++),
        SplgButton(title: 'Activo', onPressed: () => taps++),
      ])));
      await tester.tap(find.text('Apagado'));
      await tester.tap(find.byType(CircularProgressIndicator));
      expect(taps, 0);
      await tester.tap(find.text('Activo'));
      expect(taps, 1);
    });
  });

  group('Licencia de Geist', () {
    test('el OFL.txt se registra en el LicenseRegistry', () async {
      resetSplgLicensesForTest();
      final bundle =
          _FakeBundle({geistLicenseAsset: 'SIL OPEN FONT LICENSE Version 1.1'});
      registerSplgLicenses(bundle: bundle);
      final entries = await LicenseRegistry.licenses.toList();
      final geist =
          entries.where((e) => e.packages.any((p) => p.contains('Geist')));
      expect(geist, isNotEmpty);
      expect(geist.first.paragraphs.map((p) => p.text).join(' '),
          contains('SIL OPEN FONT LICENSE'));
    });

    test('el archivo existe y es la OFL de verdad', () async {
      final text = await rootBundle.loadString('fonts/geist/OFL.txt');
      expect(text, contains('SIL OPEN FONT LICENSE'));
    });
  });

  group('ApiErrorText', () {
    test('un 400/409 de negocio en castellano se muestra', () {
      expect(
          ApiErrorText.of(400,
              {'message': 'El pedido ya está en camino. Contacte al soporte.'}),
          'El pedido ya está en camino. Contacte al soporte.');
      expect(ApiErrorText.of(409, {'message': 'Ya existe un pedido pendiente'}),
          'Ya existe un pedido pendiente');
    });

    test('mensajes crudos (inglés, UUID, genéricos) no llegan al usuario', () {
      expect(
          ApiErrorText.of(400, {'message': 'reason must be shorter than 200'}),
          ApiErrorText.generic);
      expect(
          ApiErrorText.of(400, {
            'message': 'Order 3f2b8c1e-0a4d-4c3e-9b1a-2d5e6f708192 not found'
          }),
          ApiErrorText.generic);
      expect(ApiErrorText.of(403, {'message': 'Forbidden resource'}),
          ApiErrorText.forbidden);
      expect(ApiErrorText.of(500, {'message': 'Internal server error'}),
          ApiErrorText.server);
    });

    test('texto propio por código', () {
      expect(ApiErrorText.of(401, null), ApiErrorText.sessionExpired);
      expect(ApiErrorText.of(404, null), ApiErrorText.notFound);
      expect(ApiErrorText.of(429, null), ApiErrorText.tooMany);
      expect(ApiErrorText.of(503, null), ApiErrorText.server);
      expect(ApiErrorText.of(null, null), ApiErrorText.offline);
    });

    test('un 403 o 404 en castellano tampoco muestra el mensaje del back', () {
      expect(
          ApiErrorText.of(
              403, {'message': 'No tenés permiso sobre este pedido'}),
          ApiErrorText.forbidden);
    });

    test('el 409 de idempotencia no se muestra crudo', () {
      final data = {
        'message': 'Request en curso con la misma Idempotency-Key. Esperá.'
      };
      expect(ApiErrorText.isInProgress(409, data), isTrue);
      expect(ApiErrorText.businessMessage(409, data), isNull);
      expect(ApiErrorText.of(409, data), ApiErrorText.inProgress);
      expect(ApiErrorText.isInProgress(400, data), isFalse);
    });

    test('el 409 de idempotencia se reconoce por el code del back', () {
      final data = {
        'statusCode': 409,
        'error': 'Conflicto',
        'code': 'IDEMPOTENCY_IN_PROGRESS',
        'message':
            'Hay otra solicitud en curso con la misma clave de idempotencia: reintentá en unos segundos.',
      };
      expect(ApiErrorText.isInProgress(409, data), isTrue);
      expect(ApiErrorText.businessMessage(409, data), isNull);
      expect(ApiErrorText.of(409, data), ApiErrorText.inProgress);
    });

    test('el 409 de idempotencia en castellano sin code también se reconoce',
        () {
      final data = {
        'message':
            'Hay otra solicitud en curso con la misma clave de idempotencia: reintentá en unos segundos.',
      };
      expect(ApiErrorText.isInProgress(409, data), isTrue);
    });

    test('un 409 de negocio con otro code no es «en curso»', () {
      final data = {
        'code': 'PRICE_CHANGED',
        'message': 'Cambió el precio del pedido.',
      };
      expect(ApiErrorText.isInProgress(409, data), isFalse);
      expect(ApiErrorText.businessMessage(409, data),
          'Cambió el precio del pedido.');
    });

    test('reintentable: red, 429 y 5xx', () {
      expect(ApiErrorText.isRetryable(null), isTrue);
      expect(ApiErrorText.isRetryable(429), isTrue);
      expect(ApiErrorText.isRetryable(502), isTrue);
      expect(ApiErrorText.isRetryable(400), isFalse);
      expect(ApiErrorText.isRetryable(403), isFalse);
    });
  });

  group('Componentes de pantalla', () {
    testWidgets('SplgEmptyState carga la ilustración del paquete',
        (tester) async {
      await tester.pumpWidget(_wrap(const SplgEmptyState(
          message: 'No tenés ninguna entrega',
          illustration: SplgIllustration.emptyList)));
      final image = tester.widget<Image>(find.byType(Image));
      expect((image.image as AssetImage).package, 'splg_lib');
      expect(find.text('¡Nada por aquí!'), findsOneWidget);
    });

    testWidgets('SplgMenuItem seleccionado pinta el tinte', (tester) async {
      await tester.pumpWidget(_wrap(SplgMenuItem(
          label: 'Información personal',
          icon: SplgIcons.user,
          selected: true,
          onTap: () {})));
      final box = tester.widget<Container>(find
          .descendant(
              of: find.byType(SplgMenuItem), matching: find.byType(Container))
          .first);
      expect((box.decoration as BoxDecoration).color, isNotNull);
    });

    testWidgets('SplgBarChartCard dibuja una barra por valor', (tester) async {
      await tester.pumpWidget(_wrap(const SplgBarChartCard(
        title: 'Ganancia semanal',
        subtitle: '1 al 7',
        values: [0, 100, 250],
        labels: ['L', 'M', 'M'],
      )));
      expect(find.text('Ganancia semanal'), findsOneWidget);
      // El eje y la píldora de la barra resaltada.
      expect(find.text('250'), findsNWidgets(2));
    });

    testWidgets('SplgFloatingButton muestra la píldora con el texto',
        (tester) async {
      var taps = 0;
      await tester.pumpWidget(_wrap(SplgFloatingButton(
          icon: SplgIcons.menu,
          tooltip: 'Estado',
          label: 'Estado',
          onPressed: () => taps++)));
      expect(find.text('Estado'), findsOneWidget);
      await tester.tap(find.byIcon(SplgIcons.menu));
      expect(taps, 1);
    });

    testWidgets('SplgSearchField avisa lo que se escribe', (tester) async {
      String? last;
      await tester
          .pumpWidget(_wrap(SplgSearchField(onChanged: (v) => last = v)));
      await tester.enterText(find.byType(TextField), 'contra');
      expect(last, 'contra');
      expect(find.byIcon(SplgIcons.search), findsOneWidget);
    });

    testWidgets('SplgStarRating llena las estrellas del promedio',
        (tester) async {
      await tester.pumpWidget(_wrap(const SplgStarRating(rating: 3.6)));
      expect(find.byIcon(SplgIcons.star), findsNWidgets(4));
      expect(find.byIcon(SplgIcons.starEmpty), findsNWidgets(1));
    });
  });
}

class _FakeBundle extends CachingAssetBundle {
  _FakeBundle(this.files);
  final Map<String, String> files;

  @override
  Future<ByteData> load(String key) async {
    final text = files[key];
    if (text == null) throw FlutterError('no asset $key');
    final bytes = Uint8List.fromList(text.codeUnits);
    return ByteData.sublistView(bytes);
  }
}
