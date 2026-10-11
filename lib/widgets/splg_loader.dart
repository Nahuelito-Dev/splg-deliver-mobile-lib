import 'package:flutter/material.dart';

/// Indicador de carga centrado, con el color de marca (o blanco `onDark`).
class SplgLoader extends StatelessWidget {
  const SplgLoader({super.key, this.onDark = false});

  final bool onDark;

  @override
  Widget build(BuildContext context) => Center(
        child: Semantics(
          label: 'Cargando',
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color:
                onDark ? Colors.white : Theme.of(context).colorScheme.primary,
          ),
        ),
      );
}
