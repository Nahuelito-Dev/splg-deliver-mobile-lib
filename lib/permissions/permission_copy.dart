import 'app_permission.dart';

/// Textos (en castellano) que se muestran antes y después de pedir un permiso.
class PermissionCopy {
  const PermissionCopy({
    required this.title,
    required this.rationale,
    required this.deniedMessage,
    required this.settingsMessage,
  });

  /// Nombre corto del permiso para los títulos de los avisos.
  final String title;

  /// Por qué lo necesitamos (se muestra antes del pedido del sistema).
  final String rationale;

  /// Qué pasa si se niega y se puede volver a pedir.
  final String deniedMessage;

  /// Qué hacer si quedó denegado para siempre.
  final String settingsMessage;
}

const Map<AppPermission, PermissionCopy> defaultPermissionCopy = {
  AppPermission.location: PermissionCopy(
    title: 'Ubicación',
    rationale:
        'SPLG usa tu ubicación mientras la app está abierta para ubicar la entrega.',
    deniedMessage:
        'Sin la ubicación no podemos ubicar la entrega. Podés volver a intentarlo.',
    settingsMessage:
        'La ubicación está desactivada para SPLG. Activala desde Ajustes para continuar.',
  ),
  AppPermission.locationAlways: PermissionCopy(
    title: 'Ubicación en segundo plano',
    rationale:
        'SPLG necesita tu ubicación también con la app minimizada para seguir compartiendo tu posición durante una entrega.',
    deniedMessage:
        'Sin la ubicación en segundo plano, la posición se comparte sólo con la app abierta.',
    settingsMessage:
        'Para compartir tu posición con la app minimizada, elegí "Siempre" en los Ajustes de ubicación de SPLG.',
  ),
  AppPermission.camera: PermissionCopy(
    title: 'Cámara',
    rationale:
        'SPLG usa la cámara para escanear el código QR de la entrega y para sacar fotos de reclamos o incidencias.',
    deniedMessage:
        'Sin la cámara no podemos escanear el QR ni sacar la foto. Podés volver a intentarlo.',
    settingsMessage:
        'La cámara está desactivada para SPLG. Activala desde Ajustes para continuar.',
  ),
  AppPermission.photos: PermissionCopy(
    title: 'Fotos',
    rationale:
        'SPLG necesita acceder a tus fotos para que puedas adjuntar una imagen.',
    deniedMessage:
        'Sin acceso a las fotos no podemos adjuntar la imagen. Podés volver a intentarlo.',
    settingsMessage:
        'El acceso a las fotos está desactivado para SPLG. Activalo desde Ajustes para adjuntar imágenes.',
  ),
  AppPermission.notifications: PermissionCopy(
    title: 'Notificaciones',
    rationale:
        'SPLG te avisa por notificación cuando hay novedades de tu pedido o de tus entregas.',
    deniedMessage:
        'Sin notificaciones no vas a recibir los avisos. Igual podés seguir usando la app.',
    settingsMessage:
        'Las notificaciones están desactivadas para SPLG. Activalas desde Ajustes si querés recibir avisos.',
  ),
};
