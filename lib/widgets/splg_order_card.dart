import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';
import 'splg_status_badge.dart';

/// Tarjeta con borde de una lista (pedido, reclamo): ícono, título, detalle,
/// insignia de estado, valor y flecha. `highlighted` resalta el borde.
class SplgOrderCard extends StatelessWidget {
  const SplgOrderCard({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.detail,
    this.badge,
    this.badgeTone = SplgTone.neutral,
    this.icon = SplgIcons.location,
    this.highlighted = false,
  });

  final String title;
  final String? subtitle;

  /// Línea de valor ("Total: $1.500 · Efectivo").
  final String? detail;
  final String? badge;
  final SplgTone badgeTone;
  final IconData icon;
  final bool highlighted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final type = SplgType.of(context);
    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 8, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: highlighted ? brasa.primaryStrong : brasa.outline,
                  width: highlighted ? 2 : 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: brasa.primarySoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 20, color: brasa.primaryStrong),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: type.value),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 8),
                            SplgStatusBadge(label: badge!, tone: badgeTone),
                          ],
                        ],
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(subtitle!, style: type.caption),
                        ),
                      if (detail != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(detail!,
                              style: type.captionStrong
                                  .copyWith(fontWeight: FontWeight.w600)),
                        ),
                    ],
                  ),
                ),
                Icon(SplgIcons.next, size: 18, color: brasa.faint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
