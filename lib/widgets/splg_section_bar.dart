import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Franja sólida de marca con texto blanco: fecha de una entrega o cabecera
/// de un día en una lista.
class SplgSectionBar extends StatelessWidget {
  const SplgSectionBar({super.key, required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final style = SplgType.of(context).value.copyWith(color: Colors.white);
    return Container(
      color: context.brasa.primaryStrong,
      padding: const EdgeInsets.fromLTRB(15, 14, 20, 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(title, style: style)),
          if (trailing != null) Text(trailing!, style: style),
        ],
      ),
    );
  }
}
