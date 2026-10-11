import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Barra de cuenta regresiva ("La oferta vence en 22 s"). Pasa a rojo en los
/// últimos [warnAt] segundos.
class SplgCountdownBar extends StatelessWidget {
  const SplgCountdownBar({
    super.key,
    required this.remaining,
    required this.total,
    this.label = 'La oferta vence en',
    this.warnAt = 10,
    this.onDark = false,
  });

  final int remaining;
  final int total;
  final String label;
  final int warnAt;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final left = remaining < 0 ? 0 : remaining;
    final fraction = total <= 0 ? 0.0 : (left / total).clamp(0.0, 1.0);
    final warn = left <= warnAt;
    final color =
        warn ? brasa.danger : (onDark ? Colors.white : brasa.primaryStrong);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            key: const Key('countdown-bar'),
            value: fraction,
            minHeight: 6,
            backgroundColor: onDark ? Colors.white24 : brasa.outline,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 4),
        Text('$label $left s',
            key: const Key('countdown-text'),
            style: SplgType.of(context).caption.copyWith(
                color: warn
                    ? (onDark ? Colors.white : brasa.danger)
                    : (onDark ? Colors.white70 : brasa.muted))),
      ],
    );
  }
}
