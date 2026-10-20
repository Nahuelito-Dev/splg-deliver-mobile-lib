import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';
import 'splg_text_field.dart';

/// Estado de validación de un campo: neutro, válido (verde) o con error (rojo).
enum SplgFieldStatus { neutral, valid, invalid }

/// Campo de contraseña con etiqueta, ojo para mostrar/ocultar, borde verde con
/// tilde al validar y rojo con el mensaje de error.
class SplgPasswordField extends StatefulWidget {
  const SplgPasswordField({
    super.key,
    required this.label,
    required this.controller,
    this.status = SplgFieldStatus.neutral,
    this.errorText,
    this.hintText,
    this.onChanged,
    this.enabled = true,
    this.textInputAction,
    this.focusNode,
  });

  final String label;
  final TextEditingController controller;
  final SplgFieldStatus status;
  final String? errorText;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  @override
  State<SplgPasswordField> createState() => _SplgPasswordFieldState();
}

class _SplgPasswordFieldState extends State<SplgPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final type = SplgType.of(context);
    final color = switch (widget.status) {
      SplgFieldStatus.valid => brasa.success,
      SplgFieldStatus.invalid => brasa.danger,
      SplgFieldStatus.neutral => null,
    };
    final statusIcon = switch (widget.status) {
      SplgFieldStatus.valid =>
        Icon(SplgIcons.ok, color: brasa.success, size: 22),
      SplgFieldStatus.invalid =>
        Icon(SplgIcons.error, color: brasa.danger, size: 22),
      SplgFieldStatus.neutral => null,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: type.fieldLabel),
        const SizedBox(height: 10),
        TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          enabled: widget.enabled,
          obscureText: _obscure,
          onChanged: widget.onChanged,
          textInputAction: widget.textInputAction,
          autocorrect: false,
          enableSuggestions: false,
          style: type.body,
          decoration: SplgTextField.decoration(
            context,
            hint: widget.hintText ?? 'Contraseña',
            borderColor: color,
            borderWidth: 1.6,
            fill: color == null ? null : Theme.of(context).colorScheme.surface,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (statusIcon != null) statusIcon,
                IconButton(
                  tooltip:
                      _obscure ? 'Mostrar contraseña' : 'Ocultar contraseña',
                  icon: Icon(
                    _obscure ? SplgIcons.eye : SplgIcons.eyeOff,
                    size: 22,
                    color: brasa.muted,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
              ],
            ),
          ),
        ),
        if (widget.status == SplgFieldStatus.invalid &&
            widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(widget.errorText!,
                style: type.caption.copyWith(color: brasa.danger)),
          ),
      ],
    );
  }
}
