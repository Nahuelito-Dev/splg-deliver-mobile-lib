import 'dart:math' as math;

import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Geometría de mapa sin dependencias de plataforma: rumbo, distancias,
/// interpolación y decodificación de polylines.
class Geo {
  Geo._();

  static const double _earthRadius = 6371000;

  static double _rad(double d) => d * math.pi / 180;
  static double _deg(double r) => r * 180 / math.pi;

  /// Distancia en metros entre dos puntos (haversine).
  static double distanceMeters(LatLng a, LatLng b) {
    final dLat = _rad(b.latitude - a.latitude);
    final dLng = _rad(b.longitude - a.longitude);
    final h = math.pow(math.sin(dLat / 2), 2) +
        math.cos(_rad(a.latitude)) *
            math.cos(_rad(b.latitude)) *
            math.pow(math.sin(dLng / 2), 2);
    return 2 * _earthRadius * math.asin(math.min(1, math.sqrt(h)));
  }

  /// Rumbo inicial de [a] hacia [b] en grados, de 0 a 360 (0 = norte, sentido
  /// horario).
  static double bearing(LatLng a, LatLng b) {
    final lat1 = _rad(a.latitude), lat2 = _rad(b.latitude);
    final dLng = _rad(b.longitude - a.longitude);
    final y = math.sin(dLng) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLng);
    return (_deg(math.atan2(y, x)) + 360) % 360;
  }

  /// Interpolación lineal entre dos puntos (suficiente para tramos cortos).
  static LatLng lerp(LatLng a, LatLng b, double t) => LatLng(
        a.latitude + (b.latitude - a.latitude) * t,
        a.longitude + (b.longitude - a.longitude) * t,
      );

  /// Interpola dos ángulos por el camino corto: de 350 a 10 pasa por 0, no
  /// por 180. El resultado queda entre 0 y 360.
  static double lerpAngle(double a, double b, double t) {
    final delta = ((b - a + 540) % 360) - 180;
    return (a + delta * t + 360) % 360;
  }

  /// Distancia en metros de [p] al segmento [a]-[b] (proyección plana local,
  /// exacta a esta escala).
  static double distanceToSegmentMeters(LatLng p, LatLng a, LatLng b) {
    final cosLat = math.cos(_rad(p.latitude));
    double x(LatLng q) => _rad(q.longitude) * cosLat * _earthRadius;
    double y(LatLng q) => _rad(q.latitude) * _earthRadius;
    final px = x(p), py = y(p);
    final ax = x(a), ay = y(a);
    final bx = x(b), by = y(b);
    final dx = bx - ax, dy = by - ay;
    final len2 = dx * dx + dy * dy;
    final t = len2 == 0
        ? 0.0
        : (((px - ax) * dx + (py - ay) * dy) / len2).clamp(0.0, 1.0);
    final cx = ax + t * dx, cy = ay + t * dy;
    return math.sqrt(math.pow(px - cx, 2) + math.pow(py - cy, 2));
  }

  /// Distancia mínima de [p] a la línea [path]. Sin puntos: infinito.
  static double distanceToPathMeters(LatLng p, List<LatLng> path) {
    if (path.isEmpty) return double.infinity;
    if (path.length == 1) return distanceMeters(p, path.first);
    var best = double.infinity;
    for (var i = 0; i < path.length - 1; i++) {
      best = math.min(best, distanceToSegmentMeters(p, path[i], path[i + 1]));
    }
    return best;
  }

  /// Largo total de la línea en metros.
  static double pathLengthMeters(List<LatLng> path) {
    var total = 0.0;
    for (var i = 0; i < path.length - 1; i++) {
      total += distanceMeters(path[i], path[i + 1]);
    }
    return total;
  }

  /// Quita de [path] los tramos que ya quedaron atrás de [p]: devuelve la línea
  /// desde el punto más cercano en adelante, empezando en [p].
  static List<LatLng> remainingFrom(LatLng p, List<LatLng> path) {
    if (path.length < 2) return path;
    var bestIndex = 0;
    var best = double.infinity;
    for (var i = 0; i < path.length - 1; i++) {
      final d = distanceToSegmentMeters(p, path[i], path[i + 1]);
      if (d < best) {
        best = d;
        bestIndex = i;
      }
    }
    return [p, ...path.sublist(bestIndex + 1)];
  }

  /// Decodifica una polyline de Google/OSRM (algoritmo de Google, precisión 5
  /// por defecto).
  static List<LatLng> decodePolyline(String encoded, {int precision = 5}) {
    final factor = math.pow(10, precision).toDouble();
    final points = <LatLng>[];
    var index = 0, lat = 0, lng = 0;
    while (index < encoded.length) {
      for (var axis = 0; axis < 2; axis++) {
        var result = 0, shift = 0;
        int b;
        do {
          if (index >= encoded.length) return points;
          b = encoded.codeUnitAt(index++) - 63;
          result |= (b & 0x1f) << shift;
          shift += 5;
        } while (b >= 0x20);
        final d = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
        if (axis == 0) {
          lat += d;
        } else {
          lng += d;
        }
      }
      points.add(LatLng(lat / factor, lng / factor));
    }
    return points;
  }
}
