import 'package:flutter/widgets.dart';

/// Escala de tipografía y espacios de las pantallas: una unidad equivale a
/// 1/300 del ancho (acotado a 320..440 dp), de modo que `12` mide ~15,7 dp en
/// un teléfono de 393 dp.
extension SplgScale on BuildContext {
  double sp(double units) =>
      units * (MediaQuery.sizeOf(this).width.clamp(320.0, 440.0) / 300.0);
}
