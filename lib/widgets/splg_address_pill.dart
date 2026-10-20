import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Píldora de dirección: punto de color, texto y una × opcional. Con `onDark`
/// va translúcida y en blanco, para las pantallas sobre el degradé.
class SplgAddressPill extends StatelessWidget {
  const SplgAddressPill({
    super.key,
    required this.text,
    this.onTap,
    this.onClear,
    this.onDark = false,
    this.dotColor,
  });

  final String text;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool onDark;
  final Color? dotColor;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final fg = onDark ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final bg =
        onDark ? Colors.white.withValues(alpha: 0.18) : brasa.primarySoft;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      dotColor ?? (onDark ? brasa.accent : brasa.primaryStrong),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: SplgType.of(context).body.copyWith(color: fg)),
              ),
              if (onClear != null)
                IconButton(
                  tooltip: 'Quitar',
                  visualDensity: VisualDensity.compact,
                  icon: Icon(SplgIcons.close, size: 20, color: fg),
                  onPressed: onClear,
                )
              else
                const SizedBox(width: 8),
            ],
          ),
        ),
      ),
    );
  }
}
