import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Tarjeta oscura (tinta) para datos destacados: total del día, resumen del
/// pedido, etc. El texto de adentro toma `onInverseSurface`.
class SplgDarkCard extends StatelessWidget {
  const SplgDarkCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.inverseSurface,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: DefaultTextStyle.merge(
            style: TextStyle(color: scheme.onInverseSurface),
            child: child,
          ),
        ),
      ),
    );
  }
}
