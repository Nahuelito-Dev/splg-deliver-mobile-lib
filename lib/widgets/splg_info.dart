import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Bloque de datos de una ficha (perfil, vehículo): ícono + título de la
/// sección y debajo, con sangría, pares "Título: • valor".
class SplgInfoSection extends StatelessWidget {
  const SplgInfoSection({
    super.key,
    required this.icon,
    required this.title,
    required this.rows,
  });

  final IconData icon;
  final String title;
  final List<SplgInfoRow> rows;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24, color: brasa.primaryStrong),
            const SizedBox(width: 16),
            Expanded(
                child: Text(title,
                    style: SplgType.of(context)
                        .subtitle
                        .copyWith(fontWeight: FontWeight.w500))),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 42, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final r in rows)
                Padding(padding: const EdgeInsets.only(bottom: 6), child: r),
            ],
          ),
        ),
        Divider(color: brasa.primaryStrong.withValues(alpha: 0.35), height: 30),
      ],
    );
  }
}

/// Un par título / valor de [SplgInfoSection].
class SplgInfoRow extends StatelessWidget {
  const SplgInfoRow({super.key, required this.title, required this.value});

  final String title;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final type = SplgType.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: type.bodyStrong),
        Text('• ${value ?? 'Sin datos'}',
            style: type.body
                .copyWith(color: Theme.of(context).colorScheme.primary)),
      ],
    );
  }
}
