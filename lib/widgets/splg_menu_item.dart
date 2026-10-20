import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_scale.dart';
import '../theme/splg_type.dart';

/// Fila de lista con ícono, texto y flecha. Sirve para el menú lateral
/// (`dark: true`, texto blanco sobre el degradé) y para las listas de las
/// pantallas internas (texto de marca; `selected` pinta el fondo tintado).
class SplgMenuItem extends StatelessWidget {
  const SplgMenuItem({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.subtitle,
    this.dark = false,
    this.showChevron = true,
    this.destructive = false,
    this.showDivider = false,
    this.selected = false,
  });

  final String label;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;
  final bool dark;
  final bool showChevron;

  /// Acción de salida (p. ej. "Cerrar sesión"): sin flecha y con color de peligro.
  final bool destructive;
  final bool showDivider;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final type = SplgType.of(context);
    final ink = Theme.of(context).colorScheme.onSurface;
    final Color color = destructive
        ? (dark ? Colors.white : brasa.danger)
        : (dark ? Colors.white : (selected ? brasa.primaryStrong : ink));
    final Color iconColor = destructive || dark
        ? color
        : (selected ? brasa.primaryStrong : brasa.ink2);
    final Color muted = dark ? Colors.white70 : brasa.muted;
    final style =
        (dark ? type.body : type.subtitle.copyWith(fontWeight: FontWeight.w500))
            .copyWith(color: color, fontSize: context.sp(dark ? 12 : 13));

    return Semantics(
      button: true,
      label: label,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? brasa.primaryStrong.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(16),
          border: showDivider
              ? Border(
                  bottom:
                      BorderSide(color: dark ? Colors.white24 : brasa.outline))
              : null,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 24, color: iconColor),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: style),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(subtitle!,
                              style: type.caption.copyWith(color: muted)),
                        ),
                    ],
                  ),
                ),
                if (showChevron && !destructive)
                  Icon(SplgIcons.next,
                      size: 18, color: dark ? color : brasa.faint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
