import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Marca SPLG: llama + wordmark. Misma llama que el logo de la landing
/// (viewBox 24x24). El texto toma el color del tema para verse en claro y
/// oscuro.
class SplgLogo extends StatelessWidget {
  const SplgLogo({
    super.key,
    this.height = 40,
    this.showWordmark = true,
    this.color,
  });

  /// Alto de la llama; el wordmark escala con él.
  final double height;
  final bool showWordmark;

  /// Color único (llama y texto), p. ej. blanco sobre un degradé.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ink = Theme.of(context).colorScheme.onSurface;
    final flame = SizedBox(
      width: height,
      height: height,
      child: CustomPaint(painter: _FlamePainter(color ?? AppColors.llama500)),
    );
    if (!showWordmark) return Semantics(label: 'SPLG', child: flame);
    return Semantics(
      label: 'SPLG',
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            flame,
            SizedBox(width: height * 0.22),
            Text(
              'SPLG',
              style: TextStyle(
                fontSize: height * 0.82,
                height: 1,
                fontWeight: FontWeight.w700,
                letterSpacing: -height * 0.82 * 0.03,
                color: color ?? ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// La llama sola, para ícono y sellos.
Path splgFlamePath(Size size) {
  final p = Path()..moveTo(12, 1.6);
  p
    ..relativeCubicTo(2.7, 3, 3.6, 5.7, 1.9, 8.4)
    ..relativeCubicTo(1.6, -.4, 2.8, -1.5, 3.4, -3.1)
    ..relativeCubicTo(1.7, 2.3, 2.2, 5, .9, 7.7)
    ..relativeCubicTo(-1.3, 2.9, -4.2, 4.4, -7.2, 4.4)
    ..relativeCubicTo(-3.3, 0, -6.4, -1.9, -7, -5.3)
    ..relativeCubicTo(-.5, -2.8, .9, -5, 2.8, -6.6)
    ..relativeCubicTo(-.2, 1.3, .2, 2.4, 1.1, 3.1)
    ..relativeCubicTo(-.9, -3.2, .5, -6.4, 4.1, -8.6)
    ..close();
  return p.transform(
    Matrix4.diagonal3Values(size.width / 24, size.height / 24, 1).storage,
  );
}

class _FlamePainter extends CustomPainter {
  const _FlamePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      splgFlamePath(size),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _FlamePainter oldDelegate) =>
      oldDelegate.color != color;
}
