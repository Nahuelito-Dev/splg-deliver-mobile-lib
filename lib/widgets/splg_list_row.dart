import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Fila de historial: texto a la izquierda, importe en negrita y flecha a la
/// derecha, con línea inferior.
class SplgListRow extends StatelessWidget {
  const SplgListRow({
    super.key,
    required this.title,
    required this.onTap,
    this.trailing,
    this.badge,
  });

  final String title;
  final String? trailing;
  final Widget? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final type = SplgType.of(context);
    final brasa = context.brasa;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: brasa.primaryStrong.withValues(alpha: 0.3))),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: type.bodyStrong)),
            if (badge != null) ...[badge!, const SizedBox(width: 8)],
            if (trailing != null) Text(trailing!, style: type.value),
            const SizedBox(width: 5),
            Icon(SplgIcons.next, size: 18, color: brasa.primaryStrong),
          ],
        ),
      ),
    );
  }
}
