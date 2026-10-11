import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';

/// Cinco estrellas: las que entran en `rating` van llenas, el resto vacías.
class SplgStarRating extends StatelessWidget {
  const SplgStarRating({super.key, required this.rating, this.size = 25});

  final double rating;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = context.brasa.accent;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < 5; i++)
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: Icon(
              i < rating.round() ? SplgIcons.star : SplgIcons.starEmpty,
              size: size,
              color: i < rating.round() ? color : color.withValues(alpha: 0.7),
            ),
          ),
      ],
    );
  }
}
