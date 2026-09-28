# splg-lib

Paquete Dart/Flutter compartido por `splg-app-cliente` y `splg-app-chofer` (modelos de dominio y el tema, con
freezed/json_serializable). Lo consumen por `path: ../splg-lib`. Mapa del sistema: `../AGENTS.md`.

<!-- orq:gate: flutter analyze --no-fatal-infos && flutter test -->

## Reglas

- Modelos con freezed: después de tocar uno, `dart run build_runner build --delete-conflicting-outputs`
  y commitear los `.freezed.dart` / `.g.dart` generados.

- Todo cambio acá se valida con el gate de la lib **y** con el de las dos apps: una firma
  que cambia rompe a los dos consumidores.
- Nada específico de una sola app: si lo usa una, vive en esa app.
- Versionado automático por merge a `main` (ver `../AGENTS.md`); no se toca `pubspec.yaml`
  a mano para subir versión.
