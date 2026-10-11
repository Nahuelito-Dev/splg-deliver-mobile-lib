import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Botón cuadrado flotante del mapa (55x55, radio 16). Con [label] muestra al
/// lado una píldora blanca con el texto, que sale desde atrás del botón.
class SplgFloatingButton extends StatelessWidget {
  const SplgFloatingButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.label,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final String? label;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final bg = color ?? Theme.of(context).colorScheme.primary;
    final button = Material(
      color: bg,
      borderRadius: BorderRadius.circular(16),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 55,
            height: 55,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: label == null
          ? button
          : Stack(
              alignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 38),
                  child: Material(
                    color: Colors.white,
                    elevation: 3,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(26, 11, 14, 11),
                      child: Text(label!,
                          style: SplgType.of(context).value.copyWith(
                              color: color ?? context.brasa.primaryStrong)),
                    ),
                  ),
                ),
                button,
              ],
            ),
    );
  }
}
