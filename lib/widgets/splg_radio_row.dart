import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Fila con selector circular: franjas, medios de pago, motivos. La elegida se
/// tinta; sin `onTap` se ve atenuada.
class SplgRadioRow extends StatelessWidget {
  const SplgRadioRow({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.onDark = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final type = SplgType.of(context);
    final ink = Theme.of(context).colorScheme.onSurface;
    final fg = onDark ? Colors.white : ink;
    final mark = onDark
        ? Colors.white
        : (selected ? brasa.primaryStrong : brasa.outlineStrong);
    final enabled = onTap != null;
    final tint =
        onDark ? Colors.white.withValues(alpha: 0.18) : brasa.primarySoft;
    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: selected,
      enabled: enabled,
      label: title,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Material(
          color: selected ? tint : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 22, color: onDark ? fg : brasa.ink2),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: type.body.copyWith(color: fg)),
                        if (subtitle != null)
                          Text(subtitle!,
                              style: type.caption.copyWith(
                                  color: onDark ? Colors.white70 : null)),
                      ],
                    ),
                  ),
                  Icon(selected ? SplgIcons.radioOn : SplgIcons.radioOff,
                      size: 24, color: mark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
