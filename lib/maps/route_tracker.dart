import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'geo.dart';
import 'route_service.dart';

/// Cuándo vale la pena volver a pedir la ruta. Pedirla en cada posición
/// quemaría la cuota de la API, por eso hay un piso de tiempo entre pedidos.
class RouteRecalcPolicy {
  const RouteRecalcPolicy({
    this.offRouteMeters = 50,
    this.minInterval = const Duration(seconds: 10),
    this.refreshInterval = const Duration(seconds: 90),
    this.refreshMinMoveMeters = 100,
    this.stationaryMeters = 30,
    this.maxStationaryRetries = 3,
    this.maxPerMinute = 4,
  });

  /// Si el chofer no se movió más de esto desde el último pedido, un desvío no
  /// es un motivo nuevo para pedir (está quieto lejos de la calle).
  final double stationaryMeters;

  /// Pedidos seguidos por desvío estando quieto, con espera exponencial
  /// ([minInterval] x 2^n); pasado el tope no se pide hasta que se mueva.
  final int maxStationaryRetries;

  /// Tope duro de pedidos por minuto, pase lo que pase.
  final int maxPerMinute;

  /// Cuánto se puede alejar de la ruta antes de recalcular.
  final double offRouteMeters;

  /// Mínimo entre dos pedidos, aun desviado.
  final Duration minInterval;

  /// Refresco periódico (el tránsito cambia el ETA)...
  final Duration refreshInterval;

  /// ...sólo si el chofer avanzó al menos esto desde el último pedido.
  final double refreshMinMoveMeters;

  /// Si hay que pedir una ruta nueva. [route] null = todavía no hay ninguna.
  bool shouldRecalculate({
    required LatLng position,
    required SplgRoute? route,
    required DateTime? lastFetchAt,
    required LatLng? lastFetchPosition,
    required DateTime now,
  }) {
    final since = lastFetchAt == null ? null : now.difference(lastFetchAt);
    if (since != null && since < minInterval) return false;
    if (route == null || lastFetchAt == null) return true;
    if (route.isFallback) {
      // Sin ruta por calles: se reintenta con el refresco, no en cada punto.
      return since! >= refreshInterval;
    }
    if (Geo.distanceToPathMeters(position, route.points) > offRouteMeters) {
      return true;
    }
    if (since! >= refreshInterval &&
        lastFetchPosition != null &&
        Geo.distanceMeters(position, lastFetchPosition) >=
            refreshMinMoveMeters) {
      return true;
    }
    return false;
  }
}

/// Lleva la ruta vigente hacia un destino fijo: la recalcula según la
/// [RouteRecalcPolicy], recorta lo ya andado y estima lo que falta.
class RouteTracker {
  RouteTracker({
    required this.service,
    required this.destination,
    this.policy = const RouteRecalcPolicy(),
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final SplgRouteService service;
  final LatLng destination;
  final RouteRecalcPolicy policy;
  final DateTime Function() _now;

  SplgRoute? _route;
  DateTime? _lastFetchAt;
  LatLng? _lastFetchPosition;
  bool _inFlight = false;

  /// Cuántas veces se pidió la ruta al servicio.
  int fetchCount = 0;

  /// Pedidos seguidos por desvío sin que el chofer se moviera.
  int _stationaryRetries = 0;
  final List<DateTime> _recent = [];

  /// Ruta vigente (puede ser una línea recta de respaldo).
  SplgRoute? get route => _route;

  /// Línea que falta recorrer desde [position] (en la recta, hasta el destino).
  List<LatLng> remainingPoints(LatLng position) {
    final r = _route;
    if (r == null || r.isFallback) return [position, destination];
    return Geo.remainingFrom(position, r.points);
  }

  /// Metros que faltan desde [position].
  double remainingMeters(LatLng position) {
    final r = _route;
    if (r == null || r.isFallback) {
      return Geo.distanceMeters(position, destination);
    }
    return Geo.pathLengthMeters(remainingPoints(position));
  }

  /// Segundos que faltan, proporcional a lo que queda de la ruta; null si la
  /// ruta no trae estimación.
  int? remainingSeconds(LatLng position) {
    final r = _route;
    if (r == null || r.isFallback || r.durationSeconds == null) return null;
    final total = r.distanceMeters;
    if (total <= 0) return null;
    final ratio = (remainingMeters(position) / total).clamp(0.0, 1.0);
    return (r.durationSeconds! * ratio).round();
  }

  /// Informa una posición nueva. Devuelve true si la ruta cambió (se pidió una
  /// nueva). Un pedido en vuelo bloquea a los siguientes.
  Future<bool> update(LatLng position) async {
    if (_inFlight) return false;
    final now = _now();
    _recent.removeWhere((t) => now.difference(t) >= const Duration(minutes: 1));
    if (_recent.length >= policy.maxPerMinute) return false;
    final from = _lastFetchPosition;
    final moved =
        from == null ? double.infinity : Geo.distanceMeters(position, from);
    final r = _route;
    final offRoute = r != null &&
        !r.isFallback &&
        Geo.distanceToPathMeters(position, r.points) > policy.offRouteMeters;
    if (moved >= policy.stationaryMeters || !offRoute) {
      _stationaryRetries = 0;
    } else {
      // Quieto y desviado: espera exponencial y tope de reintentos.
      if (_stationaryRetries >= policy.maxStationaryRetries) return false;
      final wait = policy.minInterval * (1 << _stationaryRetries);
      final since = _lastFetchAt == null ? wait : now.difference(_lastFetchAt!);
      if (since < wait) return false;
    }
    if (!policy.shouldRecalculate(
      position: position,
      route: _route,
      lastFetchAt: _lastFetchAt,
      lastFetchPosition: _lastFetchPosition,
      now: now,
    )) {
      return false;
    }
    _inFlight = true;
    _lastFetchAt = now;
    _lastFetchPosition = position;
    _recent.add(now);
    if (offRoute && moved < policy.stationaryMeters) _stationaryRetries++;
    fetchCount++;
    try {
      _route = await service.route(position, destination);
      return true;
    } finally {
      _inFlight = false;
    }
  }
}
