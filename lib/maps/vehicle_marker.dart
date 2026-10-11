import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'geo.dart';

/// Posición y rumbo del vehículo en un instante de la animación.
class VehicleFrame {
  const VehicleFrame(this.position, this.heading);
  final LatLng position;
  final double heading;

  /// Cuadro intermedio entre [a] y [b] (0 = a, 1 = b); el rumbo gira por el
  /// camino corto.
  static VehicleFrame lerp(VehicleFrame a, VehicleFrame b, double t) =>
      VehicleFrame(
        Geo.lerp(a.position, b.position, t),
        Geo.lerpAngle(a.heading, b.heading, t),
      );
}

/// Ícono del vehículo visto desde arriba, dibujado en código (sin asset de
/// terceros): una camioneta con el frente hacia arriba (norte), para rotarla
/// con `Marker.rotation`.
class SplgVehicleIcon {
  SplgVehicleIcon._();

  /// PNG del ícono de [size] px de alto (el ancho es el 55 %).
  static Future<Uint8List> png({
    required Color body,
    Color cabin = const Color(0xFFFFFFFF),
    int size = 120,
  }) async {
    final w = (size * 0.55).round();
    final h = size;
    final recorder = ui.PictureRecorder();
    final c = Canvas(recorder);
    final shadow = Paint()
      ..color = const Color(0x33000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final bodyRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.08, h * 0.04, w * 0.84, h * 0.92),
        Radius.circular(w * 0.22));
    c.drawRRect(bodyRect.shift(const Offset(0, 3)), shadow);
    c.drawRRect(bodyRect, Paint()..color = body);
    c.drawRRect(
        bodyRect,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 0.05
          ..color = const Color(0xFFFFFFFF));
    // Parabrisas (adelante), techo y luneta.
    final glass = Paint()..color = const Color(0xFF2B2B2B);
    c.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.2, h * 0.17, w * 0.6, h * 0.14),
            Radius.circular(w * 0.08)),
        glass);
    c.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.2, h * 0.34, w * 0.6, h * 0.2),
            Radius.circular(w * 0.08)),
        Paint()..color = cabin);
    // Caja de carga atrás.
    c.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(w * 0.2, h * 0.58, w * 0.6, h * 0.32),
            Radius.circular(w * 0.06)),
        Paint()..color = const Color(0x33000000));
    final img = await recorder.endRecording().toImage(w, h);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  /// Ícono listo para `Marker.icon`.
  static Future<BitmapDescriptor> descriptor({
    required Color body,
    int size = 120,
  }) async =>
      BitmapDescriptor.bytes(await png(body: body, size: size),
          width: size * 0.55 * 0.5, height: size * 0.5);
}

/// Arma el marcador del vehículo y lo mueve con animación suave entre las
/// posiciones que recibe, girando hacia el rumbo nuevo. Se usa dentro de la
/// pantalla del mapa: `builder` recibe el [Marker] ya interpolado.
class SplgAnimatedVehicle extends StatefulWidget {
  const SplgAnimatedVehicle({
    super.key,
    required this.position,
    required this.heading,
    required this.builder,
    this.icon,
    this.duration = const Duration(milliseconds: 1000),
    this.markerId = const MarkerId('vehicle'),
  });

  final LatLng position;

  /// Rumbo en grados (0 = norte).
  final double heading;
  final BitmapDescriptor? icon;
  final Duration duration;
  final MarkerId markerId;
  final Widget Function(BuildContext context, Marker marker) builder;

  @override
  State<SplgAnimatedVehicle> createState() => _SplgAnimatedVehicleState();
}

class _SplgAnimatedVehicleState extends State<SplgAnimatedVehicle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: widget.duration);
  late VehicleFrame _from = VehicleFrame(widget.position, widget.heading);
  late VehicleFrame _to = _from;

  VehicleFrame get _current => VehicleFrame.lerp(
      _from, _to, Curves.linear.transform(_c.isCompleted ? 1 : _c.value));

  @override
  void initState() {
    super.initState();
    _c.addListener(() => setState(() {}));
  }

  @override
  void didUpdateWidget(covariant SplgAnimatedVehicle old) {
    super.didUpdateWidget(old);
    final moved =
        old.position != widget.position || old.heading != widget.heading;
    if (!moved) return;
    // Desde donde se ve ahora, para que un cambio a mitad de camino no salte.
    _from = _current;
    _to = VehicleFrame(widget.position, widget.heading);
    _c.duration = widget.duration;
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final f = _current;
    return widget.builder(
      context,
      Marker(
        markerId: widget.markerId,
        position: f.position,
        rotation: f.heading,
        flat: true,
        anchor: const Offset(0.5, 0.5),
        zIndexInt: 2,
        icon: widget.icon ?? BitmapDescriptor.defaultMarker,
      ),
    );
  }
}

/// Línea de la ruta con el estilo del recorrido: ancho 5, puntas redondas y,
/// si no es una ruta por calles, punteada.
Polyline splgRoutePolyline(
  List<LatLng> points, {
  required Color color,
  bool dashed = false,
  PolylineId id = const PolylineId('route'),
}) =>
    Polyline(
      polylineId: id,
      points: points,
      width: 5,
      color: color,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
      patterns: dashed
          ? [PatternItem.dash(18), PatternItem.gap(12)]
          : const <PatternItem>[],
    );

/// Rumbo del vehículo: el que informa el GPS si se está moviendo; si no, el
/// que sale de las dos últimas posiciones (si se movió lo suficiente); si no,
/// el [fallback] (el rumbo anterior).
double resolveHeading({
  required double? gpsHeading,
  required double? speedMps,
  required LatLng? previous,
  required LatLng current,
  required double fallback,
  double minSpeed = 1.0,
  double minMoveMeters = 3.0,
}) {
  if (gpsHeading != null &&
      gpsHeading >= 0 &&
      speedMps != null &&
      speedMps >= minSpeed) {
    return gpsHeading % 360;
  }
  if (previous != null &&
      Geo.distanceMeters(previous, current) >= minMoveMeters) {
    return Geo.bearing(previous, current);
  }
  return fallback;
}
