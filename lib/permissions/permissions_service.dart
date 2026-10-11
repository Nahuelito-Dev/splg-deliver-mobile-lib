import 'dart:developer';

import 'app_permission.dart';
import 'permission_copy.dart';
import 'permission_gateway.dart';
import 'permission_prompter.dart';

/// Pide cada permiso en el momento en que hace falta: explicación breve,
/// pedido del sistema, y si se niega, reintento o camino a Ajustes. Nunca
/// lanza: ante cualquier falla devuelve [PermissionOutcome.unavailable].
class PermissionsService {
  PermissionsService({
    required this.gateway,
    required this.prompter,
    Map<AppPermission, PermissionCopy>? copy,
  }) : _copy = {...defaultPermissionCopy, ...?copy};

  final PermissionGateway gateway;
  final PermissionPrompter prompter;
  final Map<AppPermission, PermissionCopy> _copy;

  /// Cuántas veces se vuelve a pedir tras un "denegado" antes de rendirse.
  static const maxRequests = 2;

  /// Abre los Ajustes de la app (botón "Abrir Ajustes" de las pantallas).
  Future<bool> openSettings() async {
    try {
      return await gateway.openSettings();
    } catch (e) {
      log('PermissionsService.openSettings: $e');
      return false;
    }
  }

  /// Estado actual sin pedir nada.
  Future<PermissionOutcome> status(AppPermission permission) async {
    try {
      return await gateway.status(permission);
    } catch (e) {
      log('PermissionsService.status($permission): $e');
      return PermissionOutcome.unavailable;
    }
  }

  /// Garantiza el permiso. [explain] muestra primero el motivo; [interactive]
  /// en false sólo consulta el estado (para arranques silenciosos).
  Future<PermissionOutcome> ensure(
    AppPermission permission, {
    bool explain = true,
    bool interactive = true,
  }) async {
    final copy = _copy[permission]!;
    try {
      var current = await gateway.status(permission);
      if (current.isGranted || !interactive) return current;

      var requests = 0;
      while (true) {
        if (current == PermissionOutcome.unavailable) return current;

        if (current == PermissionOutcome.permanentlyDenied) {
          if (await prompter.openSettings(permission, copy)) {
            await gateway.openSettings();
          }
          return PermissionOutcome.permanentlyDenied;
        }

        // denied: se explica (sólo la primera vez) y se pide.
        if (explain &&
            requests == 0 &&
            !await prompter.explain(permission, copy)) {
          return PermissionOutcome.denied;
        }
        current = await gateway.request(permission);
        requests++;
        if (current.isGranted) return current;
        if (current == PermissionOutcome.denied) {
          if (requests >= maxRequests ||
              !await prompter.denied(permission, copy)) {
            return PermissionOutcome.denied;
          }
        }
        // permanentlyDenied / unavailable: el ciclo lo resuelve arriba.
      }
    } catch (e) {
      log('PermissionsService.ensure($permission): $e');
      return PermissionOutcome.unavailable;
    }
  }
}
