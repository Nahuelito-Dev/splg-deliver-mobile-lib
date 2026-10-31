import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_scale.dart';
import '../theme/splg_type.dart';

/// Campo de texto sobre la superficie, con borde neutro visible en reposo,
/// radio 14, borde de marca de 2 px al enfocar y rojo en error. `maxLines`
/// mayor que 1 lo vuelve multilínea.
class SplgTextField extends StatelessWidget {
  const SplgTextField({
    super.key,
    required this.controller,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.suffixIcon,
    this.errorText,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.autofillHints,
    this.inputFormatters,
    this.prefix,
    this.minLines,
    this.maxLines,
  });

  final TextEditingController controller;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final String? errorText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefix;
  final int? minLines;
  final int? maxLines;

  static int _maxOf(int min, int? max) => max == null || max < min ? min : max;

  /// Decoración compartida con [SplgPasswordField].
  static InputDecoration decoration(
    BuildContext context, {
    String? hint,
    Widget? suffixIcon,
    Widget? prefix,
    Color? fill,
    Color? borderColor,
    double? borderWidth,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final brasa = context.brasa;
    OutlineInputBorder border(Color c, double w) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );
    final rest = borderWidth ?? 1.2;
    final focus = borderWidth == null ? 2.0 : borderWidth + 0.6;
    return InputDecoration(
      hintText: hint,
      hintStyle: SplgType.of(context).body.copyWith(color: brasa.muted),
      filled: true,
      fillColor: fill ?? scheme.surface,
      isDense: true,
      contentPadding: EdgeInsets.all(context.sp(12)),
      suffixIcon: suffixIcon,
      prefixIcon: prefix,
      prefixIconConstraints: const BoxConstraints(),
      enabledBorder: border(borderColor ?? brasa.outlineStrong, rest),
      disabledBorder: border(brasa.outline, 1),
      focusedBorder: border(borderColor ?? scheme.primary, focus),
      errorBorder: border(brasa.danger, rest + 0.3),
      focusedErrorBorder: border(brasa.danger, focus),
    );
  }

  @override
  Widget build(BuildContext context) {
    final multiline = !obscure && ((maxLines ?? 1) > 1 || (minLines ?? 1) > 1);
    final min = multiline ? (minLines ?? 1) : null;
    final max = obscure ? 1 : (multiline ? _maxOf(min!, maxLines) : 1);
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      obscureText: obscure,
      keyboardType: multiline ? TextInputType.multiline : keyboardType,
      minLines: min,
      maxLines: max,
      textInputAction: multiline ? TextInputAction.newline : textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      autocorrect: false,
      textCapitalization:
          multiline ? TextCapitalization.sentences : TextCapitalization.none,
      enableSuggestions: multiline,
      style: SplgType.of(context).body,
      decoration: decoration(context,
              hint: hint, suffixIcon: suffixIcon, prefix: prefix)
          .copyWith(
        errorText: errorText,
        errorStyle:
            SplgType.of(context).caption.copyWith(color: context.brasa.danger),
      ),
    );
  }
}
