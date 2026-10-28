import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:splg_lib/splg_lib.dart';

void main() {
  group('movimiento igual en Android e iOS', () {
    for (final (nombre, tema) in [
      ('claro', AppTheme.lightTheme),
      ('oscuro', AppTheme.darkTheme),
    ]) {
      test('tema $nombre: transición de iOS en las dos plataformas', () {
        final builders = tema.pageTransitionsTheme.builders;
        expect(builders[TargetPlatform.android],
            isA<CupertinoPageTransitionsBuilder>());
        expect(builders[TargetPlatform.iOS],
            isA<CupertinoPageTransitionsBuilder>());
      });

      test('tema $nombre: mismo efecto táctil que iOS', () {
        expect(tema.splashFactory, InkRipple.splashFactory);
      });
    }
  });
}
