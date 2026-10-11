import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_scale.dart';
import '../theme/splg_type.dart';

/// Encabezado de las pantallas internas: flecha atrás, título, campana
/// opcional y una línea inferior con sangría. `onGradient` lo pinta en blanco
/// para las pantallas con fondo degradé.
class SplgHeader extends StatelessWidget implements PreferredSizeWidget {
  const SplgHeader({
    super.key,
    required this.title,
    this.onBack,
    this.onNotifications,
    this.actions,
    this.showBack = true,
    this.centerTitle = true,
    this.onGradient = false,
  });

  final String title;

  /// Por defecto vuelve con `Navigator.maybePop`.
  final VoidCallback? onBack;

  /// Si se pasa, se muestra la campana de notificaciones.
  final VoidCallback? onNotifications;
  final List<Widget>? actions;
  final bool showBack;
  final bool centerTitle;
  final bool onGradient;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);

  @override
  Widget build(BuildContext context) {
    final strong = onGradient ? Colors.white : context.brasa.primaryStrong;
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: centerTitle,
      backgroundColor: onGradient ? Colors.transparent : null,
      leading: showBack
          ? IconButton(
              tooltip: 'Volver',
              icon: Icon(SplgIcons.back, size: 24, color: strong),
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Text(
        title,
        style: SplgType.of(context)
            .heading
            .copyWith(color: strong, fontSize: context.sp(15)),
      ),
      actions: [
        if (onNotifications != null)
          IconButton(
            tooltip: 'Notificaciones',
            icon: Icon(SplgIcons.bell, size: 24, color: strong),
            onPressed: onNotifications,
          ),
        ...?actions,
        const SizedBox(width: 6),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, indent: 20, endIndent: 20, color: strong),
      ),
    );
  }
}
