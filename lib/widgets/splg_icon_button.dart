import 'package:flutter/material.dart';

import '../theme/splg_gradients.dart';

/// Botón cuadrado con degradé de marca (55x55, radio 16): menú del inicio,
/// llamar o acciones sueltas sobre un fondo.
class SplgIconButton extends StatelessWidget {
  const SplgIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.size = 55,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: SplgGradients.button,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onPressed,
            child: Tooltip(
              message: tooltip,
              child: Icon(icon, color: Colors.white, size: size * 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
