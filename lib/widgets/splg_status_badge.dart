import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

enum SplgTone { success, danger, warn, info, neutral }

/// Píldora de estado con el color suave y el color fuerte del tono.
class SplgStatusBadge extends StatelessWidget {
  const SplgStatusBadge({super.key, required this.label, required this.tone});

  final String label;
  final SplgTone tone;

  @override
  Widget build(BuildContext context) {
    final b = context.brasa;
    final (bg, fg) = switch (tone) {
      SplgTone.success => (b.successSoft, b.success),
      SplgTone.danger => (b.dangerSoft, b.danger),
      SplgTone.warn => (b.warnSoft, b.warn),
      SplgTone.info => (b.infoSoft, b.info),
      SplgTone.neutral => (b.surfaceMuted, b.ink2),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(label,
          style: SplgType.of(context)
              .caption
              .copyWith(color: fg, fontWeight: FontWeight.w700)),
    );
  }
}
