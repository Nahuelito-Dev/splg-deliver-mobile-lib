/// Permisos del sistema que usan (o van a usar) las apps de SPLG.
enum AppPermission {
  /// Ubicación mientras la app está abierta (elegir dirección, tracking del chofer).
  location,

  /// Ubicación en segundo plano (iOS "Siempre"). Hoy ninguna app la pide: el
  /// chofer sigue enviando la posición con el servicio en primer plano.
  locationAlways,

  /// Cámara (QR de entrega, foto de reclamo o de incidencia).
  camera,

  /// Galería de fotos (adjuntar una imagen).
  photos,

  /// Notificaciones push.
  notifications,
}

/// Resultado de pedir un permiso. La app nunca debe depender de que sea
/// [granted]: todas las funciones tienen que degradar con gracia.
enum PermissionOutcome {
  granted,

  /// Denegado esta vez; se puede volver a pedir.
  denied,

  /// Denegado para siempre (o iOS ya no vuelve a preguntar): sólo se habilita
  /// desde Ajustes.
  permanentlyDenied,

  /// Restringido por el sistema (control parental / MDM) o la plataforma no
  /// lo soporta, o falló la consulta.
  unavailable,
}

extension PermissionOutcomeX on PermissionOutcome {
  bool get isGranted => this == PermissionOutcome.granted;
}
