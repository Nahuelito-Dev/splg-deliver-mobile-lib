import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Chips de filtro (Hoy / Semana / ...): el elegido va relleno, el resto con
/// borde de marca.
class SplgChoiceChips extends StatelessWidget {
  const SplgChoiceChips({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    return Wrap(
      spacing: 6,
      children: [
        for (var i = 0; i < labels.length; i++)
          ChoiceChip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            showCheckmark: false,
            selected: selected == i,
            onSelected: (_) => onSelected(i),
            label: Text(labels[i]),
            labelStyle: SplgType.of(context).bodyStrong,
            selectedColor: brasa.primaryStrong.withValues(alpha: 0.2),
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                  color:
                      selected == i ? Colors.transparent : brasa.primaryStrong),
            ),
          ),
      ],
    );
  }
}
