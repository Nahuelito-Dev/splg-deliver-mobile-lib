import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Una entrada del acordeón.
class SplgAccordionEntry {
  const SplgAccordionEntry({required this.title, required this.body});
  final String title;
  final String body;
}

/// Lista de preguntas/secciones que se despliegan de a una. La fila abierta se
/// pinta con el tinte de marca y la flecha gira; `iconUp` usa la flecha
/// arriba/abajo en lugar de la lateral.
class SplgAccordion extends StatefulWidget {
  const SplgAccordion({
    super.key,
    required this.entries,
    this.initiallyOpen,
    this.iconUp = false,
  });

  final List<SplgAccordionEntry> entries;

  /// Índice abierto al arrancar (ninguno por defecto).
  final int? initiallyOpen;
  final bool iconUp;

  @override
  State<SplgAccordion> createState() => _SplgAccordionState();
}

class _SplgAccordionState extends State<SplgAccordion> {
  int? _open;

  @override
  void initState() {
    super.initState();
    _open = widget.initiallyOpen;
  }

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final type = SplgType.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          for (var i = 0; i < widget.entries.length; i++)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: _open == i ? brasa.primarySoft : null,
                  borderRadius: _open == i ? BorderRadius.circular(16) : null,
                  border: _open == i
                      ? null
                      : Border(bottom: BorderSide(color: brasa.outline)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          setState(() => _open = _open == i ? null : i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(widget.entries[i].title,
                                  style: type.subtitle
                                      .copyWith(fontWeight: FontWeight.w500)),
                            ),
                            AnimatedRotation(
                              duration: const Duration(milliseconds: 250),
                              turns:
                                  widget.iconUp ? 0 : (_open == i ? 0.25 : 0),
                              child: Icon(
                                widget.iconUp
                                    ? (_open == i
                                        ? SplgIcons.up
                                        : SplgIcons.down)
                                    : SplgIcons.next,
                                size: 20,
                                color: brasa.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_open == i)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 16),
                        child: Text(widget.entries[i].body,
                            style: type.body
                                .copyWith(color: brasa.ink2, height: 1.45)),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
