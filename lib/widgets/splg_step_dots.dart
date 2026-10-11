import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';

/// Puntos de un asistente por pasos; el actual va lleno.
class SplgStepDots extends StatelessWidget {
  const SplgStepDots({super.key, required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final c = context.brasa.primaryStrong;
    return Semantics(
      label: 'Paso ${current + 1} de $count',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < count; i++)
            Container(
              key: Key('dot-$i'),
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == current ? c : c.withValues(alpha: 0.25),
              ),
            ),
        ],
      ),
    );
  }
}
