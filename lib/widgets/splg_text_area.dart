import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';
import 'splg_text_field.dart';

/// Texto de varias líneas con contador de caracteres ("12/300").
class SplgTextArea extends StatefulWidget {
  const SplgTextArea({
    super.key,
    required this.controller,
    this.hint,
    this.maxLength = 300,
    this.minLines = 4,
    this.enabled = true,
    this.errorText,
  });

  final TextEditingController controller;
  final String? hint;
  final int maxLength;
  final int minLines;
  final bool enabled;
  final String? errorText;

  @override
  State<SplgTextArea> createState() => _SplgTextAreaState();
}

class _SplgTextAreaState extends State<SplgTextArea> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextField(
          controller: widget.controller,
          enabled: widget.enabled,
          minLines: widget.minLines,
          maxLines: widget.minLines + 3,
          maxLength: widget.maxLength,
          textCapitalization: TextCapitalization.sentences,
          style: SplgType.of(context).body,
          buildCounter: (_,
                  {required currentLength, required isFocused, maxLength}) =>
              null,
          decoration: SplgTextField.decoration(context, hint: widget.hint)
              .copyWith(errorText: widget.errorText),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4, right: 4),
          child: Text('${widget.controller.text.length}/${widget.maxLength}',
              style: SplgType.of(context).caption.copyWith(color: brasa.muted)),
        ),
      ],
    );
  }
}
