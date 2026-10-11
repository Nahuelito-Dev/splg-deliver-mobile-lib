import 'package:permission_handler/permission_handler.dart';

import 'app_permission.dart';

/// Costura sobre `permission_handler` para poder probar el flujo sin plugin.
abstract class PermissionGateway {
  Future<PermissionOutcome> status(AppPermission permission);
  Future<PermissionOutcome> request(AppPermission permission);
  Future<bool> openSettings();
}

class PermissionHandlerGateway implements PermissionGateway {
  const PermissionHandlerGateway();

  Permission _map(AppPermission p) => switch (p) {
        AppPermission.location => Permission.locationWhenInUse,
        AppPermission.locationAlways => Permission.locationAlways,
        AppPermission.camera => Permission.camera,
        AppPermission.photos => Permission.photos,
        AppPermission.notifications => Permission.notification,
      };

  static PermissionOutcome outcomeOf(PermissionStatus s) {
    if (s.isGranted || s.isLimited || s.isProvisional) {
      return PermissionOutcome.granted;
    }
    if (s.isPermanentlyDenied) return PermissionOutcome.permanentlyDenied;
    if (s.isRestricted) return PermissionOutcome.unavailable;
    return PermissionOutcome.denied;
  }

  @override
  Future<PermissionOutcome> status(AppPermission permission) async =>
      outcomeOf(await _map(permission).status);

  @override
  Future<PermissionOutcome> request(AppPermission permission) async =>
      outcomeOf(await _map(permission).request());

  @override
  Future<bool> openSettings() => openAppSettings();
}
