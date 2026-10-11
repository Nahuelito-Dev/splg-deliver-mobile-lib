import 'package:flutter/material.dart';

import '../theme/splg_gradients.dart';

/// Fondo degradé de marca para pantallas completas (menú, notificaciones).
class SplgGradientBackground extends StatelessWidget {
  const SplgGradientBackground({
    super.key,
    required this.child,
    this.gradient = SplgGradients.surface,
  });

  final Widget child;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradient),
        child: child,
      );
}
