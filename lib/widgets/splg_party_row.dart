import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';
import 'splg_avatar.dart';

/// Persona de un pedido: avatar, nombre y una línea de apoyo (calificación,
/// teléfono). `onDark` la pinta en blanco para las pantallas sobre el degradé.
class SplgPartyRow extends StatelessWidget {
  const SplgPartyRow({
    super.key,
    required this.name,
    this.subtitle,
    this.imageUrl,
    this.initials,
    this.rating,
    this.ratingCount,
    this.onDark = false,
    this.trailing,
    this.avatarRadius = 24,
  });

  final String name;
  final String? subtitle;
  final String? imageUrl;
  final String? initials;

  /// Promedio de estrellas; null o sin calificaciones = "Sin calificaciones".
  final double? rating;
  final int? ratingCount;
  final bool onDark;
  final Widget? trailing;
  final double avatarRadius;

  @override
  Widget build(BuildContext context) {
    final type = SplgType.of(context);
    final brasa = context.brasa;
    final fg = onDark ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final soft = onDark ? Colors.white70 : brasa.muted;
    final hasRating = rating != null && (ratingCount ?? 0) > 0;
    return Row(
      children: [
        SplgAvatar(
            imageUrl: imageUrl, initials: initials, radius: avatarRadius),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: type.subtitle.copyWith(color: fg)),
              Row(
                children: [
                  if (subtitle != null)
                    Flexible(
                      child: Text('$subtitle',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: type.caption.copyWith(color: soft)),
                    ),
                  if (subtitle != null)
                    Text('  -  ', style: type.caption.copyWith(color: soft)),
                  if (hasRating) ...[
                    Icon(Icons.star_rounded, size: 13, color: brasa.accent),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                          '${rating!.toStringAsFixed(1)} ($ratingCount)',
                          key: const Key('party-rating'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: type.caption.copyWith(color: soft)),
                    ),
                  ] else
                    Flexible(
                      child: Text('Sin calificaciones',
                          key: const Key('party-no-rating'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: type.caption.copyWith(color: soft)),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
