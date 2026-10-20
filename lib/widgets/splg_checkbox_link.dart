import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_scale.dart';
import '../theme/splg_type.dart';

/// Casilla con un texto subrayado que abre un documento ("Aceptar Términos y
/// condiciones"). Tocar la casilla marca; tocar el texto abre `onLink`.
class SplgCheckboxLink extends StatelessWidget {
  const SplgCheckboxLink({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.onLink,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onLink;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    return Row(
      children: [
        Semantics(
          checked: value,
          label: label,
          child: IconButton(
            visualDensity: VisualDensity.compact,
            icon: Icon(value ? SplgIcons.checkOn : SplgIcons.checkOff,
                color: brasa.primaryStrong, size: 24),
            onPressed: () => onChanged(!value),
          ),
        ),
        Flexible(
          child: InkWell(
            onTap: onLink ?? () => onChanged(!value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(label,
                  style: onLink != null
                      ? SplgType.of(context).action.copyWith(
                          fontSize: context.sp(10),
                          decoration: TextDecoration.underline)
                      : SplgType.of(context).captionStrong),
            ),
          ),
        ),
      ],
    );
  }
}
