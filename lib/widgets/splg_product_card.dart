import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Selector de cantidad con − y +.
class SplgQuantityStepper extends StatelessWidget {
  const SplgQuantityStepper({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Quitar uno',
          visualDensity: VisualDensity.compact,
          onPressed: quantity > 0 ? onRemove : null,
          icon: Icon(SplgIcons.minus,
              color: quantity > 0 ? brasa.primaryStrong : brasa.faint),
        ),
        SizedBox(
          width: 28,
          child: Text('$quantity',
              textAlign: TextAlign.center, style: SplgType.of(context).value),
        ),
        IconButton(
          tooltip: 'Agregar uno',
          visualDensity: VisualDensity.compact,
          onPressed: onAdd,
          icon: Icon(SplgIcons.plus, color: brasa.primaryStrong),
        ),
      ],
    );
  }
}

/// Tarjeta de un producto del catálogo: imagen, nombre, precio, insignias de
/// promoción y el selector de cantidad. La elegida resalta el borde.
class SplgProductCard extends StatelessWidget {
  const SplgProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    this.promos = const [],
    this.onTap,
  });

  final Widget image;
  final String title;
  final String price;
  final int quantity;
  final List<String> promos;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final type = SplgType.of(context);
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: quantity > 0 ? brasa.primaryStrong : brasa.outline,
                width: quantity > 0 ? 2 : 1),
          ),
          child: Row(
            children: [
              SizedBox(width: 56, height: 64, child: image),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: type.subtitle),
                    const SizedBox(height: 2),
                    Text(price, style: type.value.copyWith(color: brasa.ink2)),
                    if (promos.isNotEmpty) const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        for (final p in promos)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: brasa.accentSoft,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(p,
                                style: type.caption.copyWith(
                                    color: brasa.onAccent,
                                    fontWeight: FontWeight.w700)),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SplgQuantityStepper(
                  quantity: quantity, onAdd: onAdd, onRemove: onRemove),
            ],
          ),
        ),
      ),
    );
  }
}
