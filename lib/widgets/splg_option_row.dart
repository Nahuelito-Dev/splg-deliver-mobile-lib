import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Fila de opción: ícono, título, valor a la derecha y flecha o desplegable
/// ("Forma de pago · Efectivo"). `onDark` la pinta en blanco sobre el degradé.
class SplgOptionRow extends StatelessWidget {
  const SplgOptionRow({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
    this.onDark = false,
    this.dropdown = false,
  });

  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback? onTap;
  final bool onDark;

  /// Flecha hacia abajo en lugar de hacia la derecha.
  final bool dropdown;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final type = SplgType.of(context);
    final fg = onDark ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final iconColor = onDark ? Colors.white : brasa.ink2;
    final valueColor = onDark ? brasa.accent : brasa.muted;
    return Semantics(
      button: true,
      label: value == null ? title : '$title, $value',
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Icon(icon, size: 24, color: iconColor),
              const SizedBox(width: 14),
              Expanded(
                child: Text(title,
                    style: type.body.copyWith(color: fg),
                    overflow: TextOverflow.ellipsis),
              ),
              if (value != null)
                Flexible(
                  child: Text(value!,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: type.value.copyWith(color: valueColor)),
                ),
              const SizedBox(width: 8),
              Icon(dropdown ? SplgIcons.down : SplgIcons.next,
                  size: 18, color: onDark ? fg : brasa.faint),
            ],
          ),
        ),
      ),
    );
  }
}
