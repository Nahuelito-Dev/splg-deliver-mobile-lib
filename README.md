# splg-lib — Paquete Flutter compartido

Parte de **SPLG** (Sistema de Pedidos y Logística de Garrafas). La documentación —qué es, cómo se
levanta, convenciones y contratos— está en el repositorio de documentación: `splg-docs` (`sistema/`).

## Probar un cambio de la lib contra las dos apps

La CI de `splg-app-cliente` y `splg-app-chofer` trae esta lib como carpeta hermana (`../splg-lib`):
usa la rama **con el mismo nombre** que la del PR de la app y, si no existe, `develop`.

1. Rama en la lib: por ejemplo `feat/nuevo-boton`. Abrí su PR a `develop` (corre `flutter analyze` + `flutter test` de la lib).
2. Misma rama en cada app: `feat/nuevo-boton` en `splg-app-cliente` y `splg-app-chofer` (aunque sea un commit mínimo que use el cambio) y su PR a `develop`.
3. La CI de cada app clona `splg-lib@feat/nuevo-boton` y corre `analyze` + `test` contra esa versión.
4. Se integra primero la lib a `develop`, después las apps (la CI de las apps vuelve a `develop` de la lib).

En local, las apps ya apuntan a `../splg-lib` (`path:`): alcanza con tener la rama de la lib en esa carpeta.
