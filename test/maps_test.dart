import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:splg_lib/splg_lib.dart';

const posadas = LatLng(-27.3671, -55.8961);
const destino = LatLng(-27.357482, -55.890404);

void main() {
  group('Geo', () {
    test('rumbo en los cuatro puntos cardinales', () {
      const o = LatLng(0, 0);
      expect(Geo.bearing(o, const LatLng(1, 0)), closeTo(0, 0.01));
      expect(Geo.bearing(o, const LatLng(0, 1)), closeTo(90, 0.01));
      expect(Geo.bearing(o, const LatLng(-1, 0)), closeTo(180, 0.01));
      expect(Geo.bearing(o, const LatLng(0, -1)), closeTo(270, 0.01));
    });

    test('el rumbo siempre queda entre 0 y 360', () {
      final b = Geo.bearing(const LatLng(0, 0), const LatLng(0.001, -0.001));
      expect(b, inInclusiveRange(0, 360));
      expect(b, closeTo(315, 0.1));
    });

    test('lerpAngle gira por el camino corto', () {
      expect(Geo.lerpAngle(350, 10, 0.5), closeTo(0, 1e-9));
      expect(Geo.lerpAngle(10, 350, 0.5), closeTo(0, 1e-9));
      expect(Geo.lerpAngle(0, 90, 0.5), closeTo(45, 1e-9));
      expect(Geo.lerpAngle(30, 30, 0.7), closeTo(30, 1e-9));
      expect(Geo.lerpAngle(0, 180, 0).round(), 0);
    });

    test('distancia: 1 grado de latitud ~ 111 km; mismo punto 0', () {
      expect(Geo.distanceMeters(const LatLng(0, 0), const LatLng(1, 0)),
          closeTo(111195, 300));
      expect(Geo.distanceMeters(posadas, posadas), 0);
    });

    test('distancia a una línea: sobre la línea ~0, 100 m al costado ~100', () {
      const a = LatLng(-27.0, -55.0);
      const b = LatLng(-27.0, -55.01);
      expect(Geo.distanceToPathMeters(const LatLng(-27.0, -55.005), [a, b]),
          closeTo(0, 0.5));
      // ~100 m al sur del punto medio.
      expect(Geo.distanceToPathMeters(const LatLng(-27.0009, -55.005), [a, b]),
          closeTo(100, 3));
      expect(Geo.distanceToPathMeters(posadas, []), double.infinity);
    });

    test('decodePolyline decodifica el ejemplo de Google', () {
      final p = Geo.decodePolyline('_p~iF~ps|U_ulLnnqC_mqNvxq`@');
      expect(p.length, 3);
      expect(p[0].latitude, closeTo(38.5, 1e-5));
      expect(p[0].longitude, closeTo(-120.2, 1e-5));
      expect(p[2].latitude, closeTo(43.252, 1e-5));
      expect(p[2].longitude, closeTo(-126.453, 1e-5));
    });

    test('decodePolyline tolera una cadena cortada', () {
      expect(Geo.decodePolyline('_p~iF~ps|U_ulL').length, 1);
      expect(Geo.decodePolyline(''), isEmpty);
    });

    test('remainingFrom descarta lo andado y arranca en la posición', () {
      const path = [
        LatLng(0, 0),
        LatLng(0, 0.01),
        LatLng(0, 0.02),
        LatLng(0, 0.03),
      ];
      const p = LatLng(0.00001, 0.015);
      final rest = Geo.remainingFrom(p, path);
      expect(rest.first, p);
      expect(rest.length, 3);
      expect(rest.last, path.last);
    });

    test('largo de la línea suma los tramos', () {
      expect(
          Geo.pathLengthMeters(
              [const LatLng(0, 0), const LatLng(1, 0), const LatLng(2, 0)]),
          closeTo(222390, 600));
      expect(Geo.pathLengthMeters([posadas]), 0);
    });
  });

  group('SplgRouteService', () {
    final directionsOk = {
      'status': 'OK',
      'routes': [
        {
          'overview_polyline': {'points': '_p~iF~ps|U_ulLnnqC_mqNvxq`@'},
          'legs': [
            {
              'distance': {'value': 1628},
              'duration': {'value': 240}
            }
          ],
        }
      ],
    };

    test('sin clave: línea recta y un solo aviso en el log', () async {
      final logs = <String>[];
      final s =
          SplgRouteService(log: logs.add, fetch: (_) async => fail('sin red'));
      final a = await s.route(posadas, destino);
      final b = await s.route(posadas, destino);
      expect(a.isFallback, true);
      expect(a.points, [posadas, destino]);
      expect(a.durationSeconds, isNull);
      expect(b.isFallback, true);
      expect(logs.length, 1);
      expect(logs.single, contains('DIRECTIONS_API_KEY'));
    });

    test('con clave: pide a Directions con origen, destino y la clave',
        () async {
      Uri? asked;
      final s = SplgRouteService(
          directionsKey: 'K',
          fetch: (u) async {
            asked = u;
            return directionsOk;
          });
      final r = await s.route(posadas, destino);
      expect(asked!.host, 'maps.googleapis.com');
      expect(asked!.queryParameters['key'], 'K');
      expect(asked!.queryParameters['origin'], '-27.3671,-55.8961');
      expect(asked!.queryParameters['mode'], 'driving');
      expect(r.source, RouteSource.directions);
      expect(r.points.length, 3);
      expect(r.distanceMeters, 1628);
      expect(r.durationSeconds, 240);
      expect(r.isFallback, false);
    });

    test('REQUEST_DENIED: línea recta y aviso con el motivo, una vez',
        () async {
      final logs = <String>[];
      final s = SplgRouteService(
          directionsKey: 'K',
          log: logs.add,
          fetch: (_) async => {
                'status': 'REQUEST_DENIED',
                'error_message': 'You must enable Billing',
              });
      final a = await s.route(posadas, destino);
      await s.route(posadas, destino);
      expect(a.isFallback, true);
      expect(logs.length, 1);
      expect(logs.single, contains('REQUEST_DENIED'));
      expect(logs.single, contains('Billing'));
    });

    test('un error de red no lanza: línea recta', () async {
      final logs = <String>[];
      final s = SplgRouteService(
          directionsKey: 'K',
          log: logs.add,
          fetch: (_) async => throw const FormatException('sin red'));
      expect((await s.route(posadas, destino)).isFallback, true);
      expect(logs.single, contains('sin red'));
    });

    test('respuesta OK pero sin rutas: línea recta', () async {
      final s = SplgRouteService(
          directionsKey: 'K',
          fetch: (_) async => {'status': 'OK', 'routes': []});
      expect((await s.route(posadas, destino)).isFallback, true);
    });

    test('OSRM: sin clave y lee geometría, distancia y duración', () async {
      Uri? asked;
      final s = SplgRouteService(
          preferOsrm: true,
          fetch: (u) async {
            asked = u;
            return {
              'code': 'Ok',
              'routes': [
                {
                  'geometry': '_p~iF~ps|U_ulLnnqC_mqNvxq`@',
                  'distance': 1628.2,
                  'duration': 238.5
                }
              ]
            };
          });
      final r = await s.route(posadas, destino);
      expect(asked!.host, 'router.project-osrm.org');
      expect(asked!.path, contains('-55.8961,-27.3671;-55.890404,-27.357482'));
      expect(r.source, RouteSource.osrm);
      expect(r.durationSeconds, 239);
    });
  });

  group('RouteRecalcPolicy', () {
    const policy = RouteRecalcPolicy();
    final t0 = DateTime(2026, 10, 11, 12);
    final route = SplgRoute(
      points: const [LatLng(-27.0, -55.0), LatLng(-27.0, -55.01)],
      distanceMeters: 990,
      durationSeconds: 120,
      source: RouteSource.directions,
    );

    bool should(LatLng p,
            {SplgRoute? r,
            DateTime? at,
            LatLng? from,
            required DateTime now}) =>
        policy.shouldRecalculate(
            position: p,
            route: r,
            lastFetchAt: at,
            lastFetchPosition: from,
            now: now);

    test('sin ruta pide una', () {
      expect(should(posadas, now: t0), true);
    });

    test('sobre la ruta no recalcula', () {
      expect(
          should(const LatLng(-27.0, -55.005),
              r: route,
              at: t0,
              from: const LatLng(-27.0, -55.0),
              now: t0.add(const Duration(seconds: 30))),
          false);
    });

    test('a más de 50 m de la ruta recalcula', () {
      // ~100 m al sur.
      expect(
          should(const LatLng(-27.0009, -55.005),
              r: route,
              at: t0,
              from: const LatLng(-27.0, -55.0),
              now: t0.add(const Duration(seconds: 30))),
          true);
    });

    test('a menos de 50 m (30 m) no recalcula', () {
      expect(
          should(const LatLng(-27.00027, -55.005),
              r: route,
              at: t0,
              from: const LatLng(-27.0, -55.0),
              now: t0.add(const Duration(seconds: 30))),
          false);
    });

    test('throttle: desviado pero hace menos de 10 s no vuelve a pedir', () {
      expect(
          should(const LatLng(-27.0009, -55.005),
              r: route,
              at: t0,
              from: const LatLng(-27.0, -55.0),
              now: t0.add(const Duration(seconds: 5))),
          false);
    });

    test('refresco periódico sólo si avanzó 100 m o más', () {
      final later = t0.add(const Duration(seconds: 100));
      // En la ruta, casi sin moverse: no refresca.
      expect(
          should(const LatLng(-27.0, -55.0002),
              r: route, at: t0, from: const LatLng(-27.0, -55.0), now: later),
          false);
      // Avanzó ~500 m sobre la ruta: refresca.
      expect(
          should(const LatLng(-27.0, -55.005),
              r: route, at: t0, from: const LatLng(-27.0, -55.0), now: later),
          true);
    });

    test('la línea recta de respaldo se reintenta sólo con el refresco', () {
      final straight = SplgRoute.straight(posadas, destino);
      expect(
          should(posadas,
              r: straight,
              at: t0,
              from: posadas,
              now: t0.add(const Duration(seconds: 30))),
          false);
      expect(
          should(posadas,
              r: straight,
              at: t0,
              from: posadas,
              now: t0.add(const Duration(seconds: 100))),
          true);
    });
  });

  group('RouteTracker', () {
    test('pide la ruta una vez y no en cada posición (cuota)', () async {
      var now = DateTime(2026, 10, 11, 12);
      var calls = 0;
      final tracker = RouteTracker(
        destination: const LatLng(-27.0, -55.01),
        now: () => now,
        service: SplgRouteService(
            directionsKey: 'K',
            fetch: (_) async {
              calls++;
              return {
                'status': 'OK',
                'routes': [
                  {
                    'overview_polyline': {
                      'points': Geo.decodePolyline('_p~iF~ps|U').isEmpty
                          ? ''
                          : '_p~iF~ps|U_ulLnnqC'
                    },
                    'legs': [
                      {
                        'distance': {'value': 1000},
                        'duration': {'value': 100}
                      }
                    ]
                  }
                ]
              };
            }),
      );
      expect(await tracker.update(posadas), true);
      for (var i = 0; i < 5; i++) {
        now = now.add(const Duration(seconds: 1));
        await tracker.update(posadas);
      }
      expect(calls, 1);
      expect(tracker.fetchCount, 1);
    });

    test('con la recta de respaldo mide lo que falta hasta el destino',
        () async {
      final tracker =
          RouteTracker(destination: destino, service: SplgRouteService());
      await tracker.update(posadas);
      expect(tracker.route!.isFallback, true);
      expect(tracker.remainingPoints(posadas), [posadas, destino]);
      expect(tracker.remainingMeters(posadas),
          closeTo(Geo.distanceMeters(posadas, destino), 0.01));
      expect(tracker.remainingSeconds(posadas), isNull);
    });

    test('ETA proporcional a lo que queda', () async {
      final tracker = RouteTracker(
        destination: const LatLng(0, 0.02),
        service: SplgRouteService(
            directionsKey: 'K',
            fetch: (_) async => {
                  'status': 'OK',
                  'routes': [
                    {
                      // (0,0) -> (0,0.02)
                      'overview_polyline': {'points': '???_|B'},
                      'legs': [
                        {
                          'distance': {'value': 2224},
                          'duration': {'value': 600}
                        }
                      ]
                    }
                  ]
                }),
      );
      await tracker.update(const LatLng(0, 0));
      final half = tracker.remainingSeconds(const LatLng(0, 0.01))!;
      expect(half, inInclusiveRange(290, 310));
      expect(tracker.remainingSeconds(const LatLng(0, 0.02))!, lessThan(5));
    });
  });

  group('rumbo del vehículo', () {
    test('moviéndose usa el rumbo del GPS', () {
      expect(
          resolveHeading(
              gpsHeading: 80,
              speedMps: 8,
              previous: const LatLng(0, 0),
              current: const LatLng(1, 0),
              fallback: 5),
          80);
    });

    test('casi quieto usa las dos últimas posiciones si se movió', () {
      final h = resolveHeading(
          gpsHeading: 80,
          speedMps: 0.2,
          previous: const LatLng(0, 0),
          current: const LatLng(0, 0.001),
          fallback: 5);
      expect(h, closeTo(90, 0.1));
    });

    test('sin movimiento conserva el rumbo anterior', () {
      expect(
          resolveHeading(
              gpsHeading: -1,
              speedMps: 0,
              previous: posadas,
              current: posadas,
              fallback: 123),
          123);
    });
  });

  group('SplgAnimatedVehicle', () {
    Marker? last;
    Widget host(LatLng p, double h) => MaterialApp(
          home: SplgAnimatedVehicle(
            position: p,
            heading: h,
            builder: (_, m) {
              last = m;
              return const SizedBox();
            },
          ),
        );

    testWidgets('se mueve y gira de a poco, no a saltos', (t) async {
      await t.pumpWidget(host(const LatLng(0, 0), 350));
      expect(last!.position, const LatLng(0, 0));
      expect(last!.flat, true);
      await t.pumpWidget(host(const LatLng(0, 0.001), 10));
      await t.pump(const Duration(milliseconds: 500));
      expect(last!.position.longitude, closeTo(0.0005, 1e-4));
      // A mitad de camino el rumbo pasó por el norte (0), no por el sur.
      expect(last!.rotation, anyOf(closeTo(0, 2), closeTo(360, 2)));
      await t.pump(const Duration(milliseconds: 600));
      expect(last!.position.longitude, closeTo(0.001, 1e-9));
      expect(last!.rotation, closeTo(10, 1e-6));
    });

    testWidgets('un cambio a mitad de animación arranca desde donde se ve',
        (t) async {
      await t.pumpWidget(host(const LatLng(0, 0), 0));
      await t.pumpWidget(host(const LatLng(0, 0.002), 0));
      await t.pump(const Duration(milliseconds: 500));
      final mid = last!.position.longitude;
      expect(mid, closeTo(0.001, 2e-4));
      await t.pumpWidget(host(const LatLng(0.002, 0.002), 0));
      await t.pump(const Duration(milliseconds: 1));
      expect(last!.position.longitude, closeTo(mid, 3e-4));
      await t.pump(const Duration(seconds: 2));
    });

    testWidgets('misma posición y rumbo no dispara animación', (t) async {
      await t.pumpWidget(host(const LatLng(1, 1), 90));
      await t.pumpWidget(host(const LatLng(1, 1), 90));
      expect(t.hasRunningAnimations, false);
    });
  });

  group('Ícono y polyline', () {
    testWidgets('el ícono del vehículo se dibuja como PNG', (t) async {
      final bytes = await t.runAsync(
          () => SplgVehicleIcon.png(body: const Color(0xFFD9530E), size: 80));
      expect(bytes!.length, greaterThan(100));
      // Firma PNG.
      expect(bytes.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
    });

    test('polyline: ancho 5, puntas redondas; punteada si es respaldo', () {
      final solid =
          splgRoutePolyline([posadas, destino], color: const Color(0xFFD9530E));
      expect(solid.width, 5);
      expect(solid.startCap, Cap.roundCap);
      expect(solid.patterns, isEmpty);
      final dashed = splgRoutePolyline([posadas, destino],
          color: const Color(0xFFD9530E), dashed: true);
      expect(dashed.patterns, isNotEmpty);
    });
  });

  group('Revisión: cuota y claves', () {
    Map<String, dynamic> ok() => {
          'status': 'OK',
          'routes': [
            {
              'overview_polyline': {'points': '_p~iF~ps|U_ulLnnqC'},
              'legs': [
                {
                  'distance': {'value': 1000},
                  'duration': {'value': 100}
                }
              ]
            }
          ]
        };

    test('quieto y desviado: espera exponencial y tope de reintentos',
        () async {
      var now = DateTime(2026, 10, 11, 12);
      var calls = 0;
      final tracker = RouteTracker(
        destination: const LatLng(43.0, -126.0),
        now: () => now,
        policy: const RouteRecalcPolicy(maxPerMinute: 100),
        service: SplgRouteService(
            directionsKey: 'K',
            fetch: (_) async {
              calls++;
              return ok();
            }),
      );
      // La ruta pedida va de (38.5,-120.2) a (40.7,-120.95); el chofer queda
      // lejos de esa línea y sin moverse.
      const quieto = LatLng(39.0, -124.0);
      await tracker.update(quieto); // 1: no hay ruta
      expect(calls, 1);
      final waits = <int>[];
      var last = calls;
      for (var s = 1; s <= 400; s++) {
        now = now.add(const Duration(seconds: 1));
        await tracker.update(quieto);
        if (calls != last) {
          waits.add(s);
          last = calls;
        }
      }
      // 1 inicial + 3 reintentos por desvío (10 s, 20 s, 40 s de espera) y
      // después nada mientras no se mueva.
      expect(calls, 4);
      expect(waits[1] - waits[0], greaterThanOrEqualTo(20));
      expect(waits[2] - waits[1], greaterThanOrEqualTo(40));
    });

    test('al moverse más de 30 m vuelve a poder recalcular', () async {
      var now = DateTime(2026, 10, 11, 12);
      var calls = 0;
      final tracker = RouteTracker(
        destination: const LatLng(43.0, -126.0),
        now: () => now,
        policy: const RouteRecalcPolicy(maxPerMinute: 100),
        service: SplgRouteService(
            directionsKey: 'K',
            fetch: (_) async {
              calls++;
              return ok();
            }),
      );
      await tracker.update(const LatLng(39.0, -124.0));
      now = now.add(const Duration(seconds: 15));
      await tracker.update(const LatLng(39.001, -124.0)); // ~110 m
      expect(calls, 2);
    });

    test('tope de pedidos por minuto', () async {
      var now = DateTime(2026, 10, 11, 12);
      var calls = 0;
      final tracker = RouteTracker(
        destination: const LatLng(43.0, -126.0),
        now: () => now,
        policy: const RouteRecalcPolicy(
            minInterval: Duration(seconds: 1), maxPerMinute: 3),
        service: SplgRouteService(
            directionsKey: 'K',
            fetch: (_) async {
              calls++;
              return ok();
            }),
      );
      // Se mueve 200 m cada segundo, siempre fuera de la ruta: sin el tope
      // pediría en cada posición.
      for (var i = 0; i < 20; i++) {
        now = now.add(const Duration(seconds: 1));
        await tracker.update(LatLng(39.0 + i * 0.002, -124.0));
      }
      expect(calls, 3);
      now = now.add(const Duration(minutes: 2));
      await tracker.update(const LatLng(39.5, -124.0));
      expect(calls, 4);
    });

    test('OSRM se ignora en release y avisa; en debug se usa', () async {
      final logs = <String>[];
      var fetched = 0;
      final rel = SplgRouteService(
          preferOsrm: true,
          release: true,
          log: logs.add,
          fetch: (_) async {
            fetched++;
            return {};
          });
      final r = await rel.route(posadas, destino);
      expect(r.isFallback, true);
      expect(fetched, 0);
      expect(rel.preferOsrm, false);
      expect(logs.single, contains('osrm'));
      final dbg = SplgRouteService(preferOsrm: true, release: false);
      expect(dbg.preferOsrm, true);
    });

    test('OSRM en release con clave de Directions usa Directions', () async {
      Uri? asked;
      final s = SplgRouteService(
          preferOsrm: true,
          release: true,
          directionsKey: 'K',
          fetch: (u) async {
            asked = u;
            return ok();
          });
      await s.route(posadas, destino);
      expect(asked!.host, 'maps.googleapis.com');
    });

    test('la clave nunca aparece en los logs, ni en un error con la URL',
        () async {
      final logs = <String>[];
      final s = SplgRouteService(
          directionsKey: 'SECRETA123',
          log: logs.add,
          fetch: (u) async => throw HttpException('falló', uri: u));
      await s.route(posadas, destino);
      expect(logs.single, isNot(contains('SECRETA123')));
      expect(logs.single, contains('key=***'));
      expect(
          SplgRouteService.sanitize('x?a=1&key=ABC&b=2'), 'x?a=1&key=***&b=2');
    });

    test('en release no se loguea nada de la ruta', () async {
      final logs = <String>[];
      final s = SplgRouteService(release: true, log: logs.add);
      await s.route(posadas, destino);
      expect(logs, isEmpty);
    });
  });
}
