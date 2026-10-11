import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Opción de un [SplgChoiceDialog].
class SplgChoice<T> {
  const SplgChoice(this.value, this.label, {this.bold = false});
  final T value;
  final String label;

  /// La opción por defecto va en negrita.
  final bool bold;
}

/// Diálogo blanco con un mensaje y una lista de opciones de texto separadas
/// por líneas: el "Al aceptar el pedido debés elegir un tipo de mapa".
class SplgChoiceDialog<T> extends StatelessWidget {
  const SplgChoiceDialog({
    super.key,
    required this.message,
    required this.choices,
    this.boldPrefix,
  });

  final String message;
  final List<SplgChoice<T>> choices;

  /// Palabra del mensaje que se resalta en negrita (ej. "aceptar").
  final String? boldPrefix;

  @override
  Widget build(BuildContext context) {
    final type = SplgType.of(context);
    final brasa = context.brasa;
    final spans = <InlineSpan>[];
    final b = boldPrefix;
    if (b != null && message.contains(b)) {
      final i = message.indexOf(b);
      spans
        ..add(TextSpan(text: message.substring(0, i)))
        ..add(TextSpan(
            text: b, style: const TextStyle(fontWeight: FontWeight.w700)))
        ..add(TextSpan(text: message.substring(i + b.length)));
    } else {
      spans.add(TextSpan(text: message));
    }
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 36),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Text.rich(TextSpan(children: spans),
                textAlign: TextAlign.center, style: type.body),
          ),
          for (final c in choices) ...[
            Divider(height: 1, color: brasa.outline),
            InkWell(
              onTap: () => Navigator.of(context).pop(c.value),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: Center(
                  child: Text(c.label,
                      style: type.body.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight:
                              c.bold ? FontWeight.w700 : FontWeight.w500)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
