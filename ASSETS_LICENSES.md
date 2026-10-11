# Licencias de assets de splg-lib

Todo lo que viaja en la lib tiene licencia libre. Si se agrega un asset, se
anota acá con su fuente y su licencia.

## Íconos

| Qué | Fuente | Licencia |
|---|---|---|
| Íconos de la interfaz (flechas, menú, perfil, estadísticas, ayuda, etc.) | Paquete `phosphor_flutter` 2.1.0 (https://pub.dev/packages/phosphor_flutter), de Phosphor Icons (https://phosphoricons.com) | MIT |

El mapeo está en `lib/icons/splg_icons.dart`.

## Ilustraciones 3D (`assets/illustrations/`)

Todas son del set "3D Icons" de realvjy (https://3dicons.co,
https://github.com/realvjy/3dicons), estilo `color`, ángulo `dynamic`
(`mail_sent.png`: ángulo `front`), descargadas del CDN oficial
(`https://3dicons.sgp1.cdn.digitaloceanspaces.com/v1/<ángulo>/color/<nombre>-<ángulo>-color.png`).
Licencia: CC0 1.0 (dominio público; el repositorio la declara en su
`LICENSE`). PNG de 400 px, sin modificar.

| Archivo | Ícono original | Se usa en |
|---|---|---|
| `welcome.png` | `map-pin` | Bienvenida |
| `recover_password.png` | `lock` | Recuperar contraseña |
| `mail_sent.png` | `mail` (ángulo `front`) | Login (arriba, grande) y "Revisá tu correo" |
| `empty_deliveries.png` | `bag` | Estado vacío de listas (Mis entregas) |
| `empty_notifications.png` | `zoom` | Notificaciones vacías |
| `success.png` | `target` | Contraseña actualizada |
| `error.png` | `flash` | Error al cargar |

## Tipografía

| Qué | Fuente | Licencia |
|---|---|---|
| Geist (`fonts/geist/`) | https://github.com/vercel/geist-font | SIL Open Font License 1.1 (`fonts/geist/OFL.txt`, registrada con `registerSplgLicenses()`) |
