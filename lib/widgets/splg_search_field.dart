import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_scale.dart';
import '../theme/splg_type.dart';

/// Campo de búsqueda de las pantallas de ayuda: borde de marca de 2 px, radio
/// 14 y lupa a la izquierda.
class SplgSearchField extends StatelessWidget {
  const SplgSearchField({
    super.key,
    this.controller,
    this.hint = 'Buscar por...',
    this.onChanged,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: brasa.primaryStrong, width: 2),
    );
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: SplgType.of(context).body,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: SplgType.of(context)
            .body
            .copyWith(color: brasa.primaryStrong.withValues(alpha: 0.6)),
        isDense: true,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
        contentPadding: EdgeInsets.symmetric(vertical: context.sp(9)),
        prefixIcon:
            Icon(SplgIcons.search, size: 22, color: brasa.primaryStrong),
        enabledBorder: border,
        focusedBorder: border,
        border: border,
      ),
    );
  }
}
