import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'geo.dart';

/// De dónde salió la ruta.
enum RouteSource {
  /// Directions API de Google (necesita clave con Directions habilitada).
  directions,

  /// Servidor público de OSRM (OpenStreetMap): sólo para desarrollo y demos,
  /// sin clave y sin garantías de servicio.
  osrm,

  /// Línea recta entre los dos puntos: no hubo ruta por calles.
  straight,
}

/// Ruta entre dos puntos: la línea, cuánto mide y cuánto se tarda.
class SplgRoute {
  const SplgRoute({
    required this.points,
    required this.distanceMeters,
    required this.source,
    this.durationSeconds,
  });

  final List<LatLng> points;
  final double distanceMeters;

  /// Segundos estimados; null en la línea recta (no hay dato de tránsito).
  final int? durationSeconds;
  final RouteSource source;

  /// No es una ruta por calles (se dibuja punteada).
  bool get isFallback => source == RouteSource.straight;

  /// Línea recta de [from] a [to].
  factory SplgRoute.straight(LatLng from, LatLng to) => SplgRoute(
        points: [from, to],
        distanceMeters: Geo.distanceMeters(from, to),
        source: RouteSource.straight,
      );
}

/// Trae el JSON de [uri]. Se inyecta para poder probar sin red.
typedef JsonFetcher = Future<Map<String, dynamic>> Function(Uri uri);

Future<Map<String, dynamic>> _httpFetch(Uri uri) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 6);
  try {
    final req = await client.getUrl(uri).timeout(const Duration(seconds: 8));
    final res = await req.close().timeout(const Duration(seconds: 8));
    final body = await res.transform(utf8.decoder).join();
    return Map<String, dynamic>.from(jsonDecode(body) as Map);
  } finally {
    client.close(force: true);
  }
}

/// Pide rutas por calles. Con `directionsKey` usa la Directions API de Google;
/// sin clave (o si el pedido falla) devuelve una línea recta y lo avisa por
/// [log] una sola vez, sin romper la pantalla.
///
/// La clave entra por `--dart-define=DIRECTIONS_API_KEY`, nunca se versiona.
/// Directions es un web service: la clave tiene que tener habilitada la
/// "Directions API" (con facturación) y no estar restringida sólo al SDK de
/// iOS/Android.
class SplgRouteService {
  SplgRouteService({
    this.directionsKey = '',
    bool preferOsrm = false,
    JsonFetcher? fetch,
    void Function(String message)? log,
    bool? release,
  })  : _fetch = fetch ?? _httpFetch,
        _log = log,
        _release = release ?? kReleaseMode,
        _requestedOsrm = preferOsrm,
        preferOsrm = preferOsrm && !(release ?? kReleaseMode);

  final String directionsKey;

  /// Usa OSRM en vez de Google. Sólo en debug/profile: en release se ignora
  /// (el servidor público no es para producción) y se avisa.
  final bool preferOsrm;
  final bool _release;
  final JsonFetcher _fetch;
  final void Function(String message)? _log;

  final Set<String> _logged = {};
  bool _osrmWarned = false;
  final bool _requestedOsrm;

  bool get hasKey => directionsKey.isNotEmpty;

  /// Si pide rutas reales (hay clave de Google u OSRM elegido).
  bool get canRoute => preferOsrm || hasKey;

  /// Avisa una sola vez por [key], sólo en debug y sin la clave de la API:
  /// nada de lo que se loguea puede contener `key=...`.
  void _warn(String key, String message) {
    if (_release) return;
    if (_logged.add(key)) _log?.call(sanitize(message));
  }

  /// Aviso de configuración: el único que sale también en release (sin datos
  /// sensibles) para que no pase desapercibido.
  void _warnAlways(String key, String message) {
    if (_logged.add(key)) _log?.call(sanitize(message));
  }

  /// Saca la clave de cualquier texto con una URL (`key=...`).
  @visibleForTesting
  static String sanitize(String text) =>
      text.replaceAll(RegExp(r'key=[^&\s)\x27"]*'), 'key=***');

  /// Ruta de [from] a [to]; nunca lanza: ante cualquier problema devuelve la
  /// línea recta.
  Future<SplgRoute> route(LatLng from, LatLng to) async {
    if (_requestedOsrm && _release && !_osrmWarned) {
      _osrmWarned = true;
      _warnAlways('osrm-release',
          'ROUTE_PROVIDER=osrm se ignora fuera de debug: se usa Directions o la línea recta.');
    }
    if (!canRoute) {
      _warn(
          'sin-clave',
          'Sin DIRECTIONS_API_KEY: el recorrido va en línea recta. '
              'Pasá --dart-define=DIRECTIONS_API_KEY=<clave con Directions API>.');
      return SplgRoute.straight(from, to);
    }
    try {
      final r =
          preferOsrm ? await _osrm(from, to) : await _directions(from, to);
      if (r != null) return r;
    } catch (e) {
      _warn('error', 'No se pudo pedir la ruta ($e): se usa la línea recta.');
    }
    return SplgRoute.straight(from, to);
  }

  Future<SplgRoute?> _directions(LatLng from, LatLng to) async {
    final uri = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': '${from.latitude},${from.longitude}',
      'destination': '${to.latitude},${to.longitude}',
      'mode': 'driving',
      'key': directionsKey,
    });
    final json = await _fetch(uri);
    final status = json['status']?.toString();
    if (status != 'OK') {
      _warn(
          'directions-$status',
          'Directions API respondió $status'
              '${json['error_message'] != null ? ': ${json['error_message']}' : ''}. '
              'Se usa la línea recta.');
      return null;
    }
    final routes = json['routes'] as List?;
    if (routes == null || routes.isEmpty) return null;
    final route = Map<String, dynamic>.from(routes.first as Map);
    final encoded = (route['overview_polyline'] as Map?)?['points']?.toString();
    if (encoded == null || encoded.isEmpty) return null;
    final points = Geo.decodePolyline(encoded);
    if (points.length < 2) return null;
    var dist = 0.0, secs = 0;
    for (final leg in (route['legs'] as List? ?? const []).whereType<Map>()) {
      dist += ((leg['distance'] as Map?)?['value'] as num?)?.toDouble() ?? 0;
      secs += ((leg['duration'] as Map?)?['value'] as num?)?.toInt() ?? 0;
    }
    return SplgRoute(
      points: points,
      distanceMeters: dist > 0 ? dist : Geo.pathLengthMeters(points),
      durationSeconds: secs > 0 ? secs : null,
      source: RouteSource.directions,
    );
  }

  Future<SplgRoute?> _osrm(LatLng from, LatLng to) async {
    final uri = Uri.https(
      'router.project-osrm.org',
      '/route/v1/driving/${from.longitude},${from.latitude};${to.longitude},${to.latitude}',
      {'overview': 'full', 'geometries': 'polyline'},
    );
    final json = await _fetch(uri);
    if (json['code'] != 'Ok') {
      _warn('osrm-${json['code']}',
          'OSRM respondió ${json['code']}. Se usa la línea recta.');
      return null;
    }
    final routes = json['routes'] as List?;
    if (routes == null || routes.isEmpty) return null;
    final route = Map<String, dynamic>.from(routes.first as Map);
    final points = Geo.decodePolyline(route['geometry'].toString());
    if (points.length < 2) return null;
    return SplgRoute(
      points: points,
      distanceMeters: (route['distance'] as num?)?.toDouble() ??
          Geo.pathLengthMeters(points),
      durationSeconds: (route['duration'] as num?)?.round(),
      source: RouteSource.osrm,
    );
  }
}
