import 'package:flutter/material.dart';

import 'app_permission.dart';
import 'permission_copy.dart';

/// Interfaz de los avisos del flujo de permisos (separada para poder probarlo).
abstract class PermissionPrompter {
  /// Explicación previa. `true` = el usuario quiere seguir y se muestra el
  /// pedido del sistema.
  Future<bool> explain(AppPermission permission, PermissionCopy copy);

  /// Se negó pero se puede volver a pedir. `true` = reintentar.
  Future<bool> denied(AppPermission permission, PermissionCopy copy);

  /// Quedó denegado para siempre. `true` = abrir Ajustes.
  Future<bool> openSettings(AppPermission permission, PermissionCopy copy);
}

/// Avisos con `AlertDialog` sobre el navegador de la app (`navigatorKey`), sin
/// necesitar un `BuildContext` en los ViewModels. Si todavía no hay navegador,
/// no muestra nada: la explicación se omite y los demás avisos devuelven false.
class NavigatorPermissionPrompter implements PermissionPrompter {
  NavigatorPermissionPrompter(this.navigatorKey);

  final GlobalKey<NavigatorState>? navigatorKey;

  Future<bool> _ask({
    required String title,
    required String message,
    required String confirm,
    required String cancel,
  }) async {
    final context = navigatorKey?.currentContext;
    if (context == null || !context.mounted) return false;
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirm),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Future<bool> explain(AppPermission permission, PermissionCopy copy) async {
    if (navigatorKey?.currentContext == null) return true;
    return _ask(
      title: copy.title,
      message: copy.rationale,
      confirm: 'Continuar',
      cancel: 'Ahora no',
    );
  }

  @override
  Future<bool> denied(AppPermission permission, PermissionCopy copy) => _ask(
        title: copy.title,
        message: copy.deniedMessage,
        confirm: 'Reintentar',
        cancel: 'Cerrar',
      );

  @override
  Future<bool> openSettings(AppPermission permission, PermissionCopy copy) =>
      _ask(
        title: copy.title,
        message: copy.settingsMessage,
        confirm: 'Abrir Ajustes',
        cancel: 'Ahora no',
      );
}
