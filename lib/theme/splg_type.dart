import 'package:flutter/material.dart';

import 'brasa_palette.dart';
import 'splg_scale.dart';

/// Estilos de texto de las pantallas. Los tamaños salen de [SplgScale]; el
/// color de la paleta Brasa (tinta para el texto, apagado para lo secundario;
/// la marca sólo en [action]) y la fuente (Geist) del tema.
class SplgType {
  SplgType._(this._context);

  factory SplgType.of(BuildContext context) => SplgType._(context);

  final BuildContext _context;

  Color get _strong => _context.brasa.primaryStrong;
  Color get _ink2 => _context.brasa.ink2;
  Color get _ink => Theme.of(_context).colorScheme.onSurface;
  Color get _soft => _context.brasa.muted;

  // La fuente va explícita: chips, botones y otros componentes reemplazan el
  // estilo del tema en lugar de mezclarlo y caerían a la fuente del sistema.
  TextStyle _s(double units, FontWeight w, Color c) => TextStyle(
        fontFamily: 'Geist',
        package: 'splg_lib',
        fontSize: _context.sp(units),
        fontWeight: w,
        color: c,
      );

  /// Título de pantalla principal.
  TextStyle get title => _s(22, FontWeight.w700, _ink);

  /// Título de pantalla secundaria / de bloque.
  TextStyle get heading => _s(18, FontWeight.w700, _ink);

  /// Subtítulo en negrita.
  TextStyle get subtitle => _s(14, FontWeight.w700, _ink);

  /// Etiqueta de campo.
  TextStyle get label => _s(14, FontWeight.w600, _ink2);

  /// Etiqueta de campo de formulario, sobre el campo.
  TextStyle get fieldLabel => _s(12, FontWeight.w600, _ink2);

  /// Texto corriente.
  TextStyle get body => _s(12, FontWeight.w500, _ink);

  /// Texto corriente resaltado (tinta, más peso).
  TextStyle get bodyStrong => _s(12, FontWeight.w600, _ink);

  /// Valor en negrita.
  TextStyle get value => _s(12, FontWeight.w700, _ink);

  /// Texto chico de apoyo.
  TextStyle get caption => _s(10, FontWeight.w400, _soft);

  /// Texto chico de apoyo, en tinta secundaria.
  TextStyle get captionStrong => _s(10, FontWeight.w500, _ink2);

  /// Cifra grande (totales).
  TextStyle get amount => _s(30, FontWeight.w600, _ink);

  /// Enlace o acción de texto: el único texto corriente en color de marca.
  TextStyle get action => _s(12, FontWeight.w600, _strong);

  /// Texto de botón.
  TextStyle get button => _s(14, FontWeight.w600, Colors.white);
}
