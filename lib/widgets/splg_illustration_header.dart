import 'package:flutter/material.dart';

import '../theme/splg_gradients.dart';
import '../theme/splg_scale.dart';
import 'splg_illustration.dart';

/// Cabecera con degradé y la parte de abajo curva, con una ilustración
/// centrada: registro y recuperar contraseña.
class SplgIllustrationHeader extends StatelessWidget {
  const SplgIllustrationHeader({
    super.key,
    required this.illustration,
    this.height,
  });

  final SplgIllustration illustration;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final h = height ?? context.sp(70);
    return ClipPath(
      clipper: const _CurveClipper(),
      child: Container(
        width: double.infinity,
        height: h + MediaQuery.paddingOf(context).top,
        decoration: const BoxDecoration(gradient: SplgGradients.splash),
        padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top + 4),
        child: Center(child: illustration.image(height: h - 16)),
      ),
    );
  }
}

class _CurveClipper extends CustomClipper<Path> {
  const _CurveClipper();

  @override
  Path getClip(Size size) {
    final p = Path()
      ..lineTo(0, size.height - 24)
      ..quadraticBezierTo(
          size.width / 2, size.height + 12, size.width, size.height - 24)
      ..lineTo(size.width, 0)
      ..close();
    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
