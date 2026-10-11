import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Fila de dirección de un pedido: círculo con ícono, texto y una línea de
/// apoyo (distancia, franja).
class SplgRouteRow extends StatelessWidget {
  const SplgRouteRow({
    super.key,
    required this.icon,
    required this.text,
    this.caption,
    this.color,
    this.onDark = false,
  });

  final IconData icon;
  final String text;
  final String? caption;
  final Color? color;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final type = SplgType.of(context);
    final brasa = context.brasa;
    final fg = onDark ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final soft = onDark ? Colors.white70 : brasa.muted;
    final dot = color ?? (onDark ? brasa.accent : brasa.primaryStrong);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          child: Icon(icon, size: 14, color: Colors.white),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text, style: type.body.copyWith(color: fg)),
              if (caption != null)
                Text(caption!, style: type.caption.copyWith(color: soft)),
            ],
          ),
        ),
      ],
    );
  }
}
