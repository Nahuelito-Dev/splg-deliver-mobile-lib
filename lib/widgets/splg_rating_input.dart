import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';

/// Cinco estrellas tocables. `value` 0 = sin elegir.
class SplgRatingInput extends StatelessWidget {
  const SplgRatingInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = 40,
    this.enabled = true,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final double size;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final color = context.brasa.accent;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++)
          IconButton(
            tooltip: '$i ${i == 1 ? 'estrella' : 'estrellas'}',
            iconSize: size,
            onPressed: enabled ? () => onChanged(i) : null,
            icon: Icon(i <= value ? SplgIcons.star : SplgIcons.starEmpty,
                color: color),
          ),
      ],
    );
  }
}
