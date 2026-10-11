import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_gradients.dart';
import '../theme/splg_scale.dart';
import '../theme/splg_type.dart';

/// Variantes del botón de las pantallas.
enum SplgButtonStyle {
  /// Degradé de marca con texto blanco.
  filled,

  /// Fondo claro y borde de marca de 2 px.
  outlined,

  /// Blanco con texto de marca, para fondos degradé.
  white,

  /// Acción destructiva.
  danger,

  /// Transparente con borde y texto blancos, para fondos degradé.
  ghost,
}

/// Botón de las pantallas (degradé, radio 16, alto 50). Sin `onPressed` se ve
/// atenuado; con `loading` muestra el indicador y no responde.
class SplgButton extends StatelessWidget {
  const SplgButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.style = SplgButtonStyle.filled,
    this.loading = false,
    this.radius = 16,
    this.expand = true,
  });

  final String title;
  final VoidCallback? onPressed;
  final SplgButtonStyle style;
  final bool loading;
  final double radius;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final primary = Theme.of(context).colorScheme.primary;
    final enabled = onPressed != null && !loading;
    final shape = BorderRadius.circular(radius);

    Color fg;
    BoxDecoration deco;
    switch (style) {
      case SplgButtonStyle.filled:
        fg = Colors.white;
        deco = enabled
            ? BoxDecoration(gradient: SplgGradients.button, borderRadius: shape)
            : BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: shape,
                border: Border.all(color: primary.withValues(alpha: 0.35)),
              );
        if (!enabled && !loading) fg = primary.withValues(alpha: 0.45);
        if (loading) {
          deco = BoxDecoration(
              gradient: SplgGradients.button, borderRadius: shape);
        }
      case SplgButtonStyle.outlined:
        fg = enabled ? brasa.primaryStrong : brasa.faint;
        deco = BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: shape,
          border: Border.all(
              color: enabled ? primary : primary.withValues(alpha: 0.35),
              width: 2),
        );
      case SplgButtonStyle.white:
        fg = brasa.primaryStrong;
        deco = BoxDecoration(color: Colors.white, borderRadius: shape);
      case SplgButtonStyle.danger:
        fg = Colors.white;
        deco = BoxDecoration(color: brasa.danger, borderRadius: shape);
      case SplgButtonStyle.ghost:
        fg = Colors.white;
        deco = BoxDecoration(
          borderRadius: shape,
          border: Border.all(
              color: enabled ? Colors.white : Colors.white54, width: 2),
        );
    }

    final textStyle = SplgType.of(context).button.copyWith(color: fg);
    final label = loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
          )
        : Text(title, style: textStyle, textAlign: TextAlign.center);

    return Semantics(
      button: true,
      enabled: enabled,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: deco,
          child: InkWell(
            borderRadius: shape,
            onTap: enabled ? onPressed : null,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: context.sp(13) + 30,
                minWidth: expand ? double.infinity : 0,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Center(widthFactor: expand ? null : 1, child: label),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
