import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_scale.dart';
import '../theme/splg_type.dart';
import 'splg_illustration.dart';

/// Estado vacío: ilustración 3D, título "¡Nada por aquí!" y un mensaje.
/// `onDark` pone los textos en blanco para las pantallas con fondo degradé.
/// `action` es opcional (p. ej. "Reintentar").
class SplgEmptyState extends StatelessWidget {
  const SplgEmptyState({
    super.key,
    required this.message,
    this.title = '¡Nada por aquí!',
    this.illustration = SplgIllustration.emptyList,
    this.action,
    this.onDark = false,
    this.imageWidth,
  });

  final String title;
  final String message;
  final SplgIllustration illustration;
  final Widget? action;
  final bool onDark;

  /// Ancho de la ilustración (por defecto ~la mitad de la pantalla).
  final double? imageWidth;

  @override
  Widget build(BuildContext context) {
    final type = SplgType.of(context);
    final brasa = context.brasa;
    final titleColor = onDark ? Colors.white : brasa.primaryStrong;
    final textColor = onDark ? Colors.white : brasa.ink2;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            illustration.image(width: imageWidth ?? context.sp(150)),
            const SizedBox(height: 12),
            Text(title,
                style: type.title.copyWith(color: titleColor),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message,
                style: type.body.copyWith(color: textColor),
                textAlign: TextAlign.center),
            if (action != null) ...[const SizedBox(height: 20), action!],
          ],
        ),
      ),
    );
  }
}
