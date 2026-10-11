import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_gradients.dart';
import '../theme/splg_scale.dart';
import '../theme/splg_type.dart';

/// Botón de acción de las hojas del viaje: un cuadro blanco con la flecha a la
/// izquierda y el texto centrado.
class SplgActionButton extends StatelessWidget {
  const SplgActionButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.loading = false,
    this.danger = false,
    this.icon = SplgIcons.next,
  });

  final String title;
  final VoidCallback? onPressed;
  final bool loading;
  final bool danger;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final enabled = onPressed != null && !loading;
    final shape = BorderRadius.circular(16);
    return Semantics(
      button: true,
      enabled: enabled,
      label: title,
      child: Opacity(
        opacity: onPressed == null && !loading ? 0.5 : 1,
        child: Material(
          color: Colors.transparent,
          child: Ink(
            height: context.sp(13) + 34,
            decoration: BoxDecoration(
              gradient: danger ? null : SplgGradients.button,
              color: danger ? brasa.danger : null,
              borderRadius: shape,
            ),
            child: InkWell(
              borderRadius: shape,
              onTap: enabled ? onPressed : null,
              child: Row(
                children: [
                  Container(
                    key: const Key('action-chip'),
                    width: context.sp(13) + 34,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: loading
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2.2,
                                  color: danger
                                      ? brasa.danger
                                      : brasa.primaryStrong),
                            )
                          : Icon(icon,
                              size: 20,
                              color:
                                  danger ? brasa.danger : brasa.primaryStrong),
                    ),
                  ),
                  Expanded(
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: SplgType.of(context).button),
                  ),
                  SizedBox(width: context.sp(13) + 34),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
