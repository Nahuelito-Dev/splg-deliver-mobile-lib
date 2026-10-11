import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_scale.dart';
import '../theme/splg_type.dart';

/// Campo de texto relleno con el tinte de marca (10 %), sin borde en reposo,
/// radio 14 y borde de marca al enfocar.
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

  /// Decoración compartida con [SplgPasswordField].
  static InputDecoration decoration(
    BuildContext context, {
    String? hint,
    Widget? suffixIcon,
    Widget? prefix,
    Color? fill,
    Color? borderColor,
    double borderWidth = 1.5,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final brasa = context.brasa;
    OutlineInputBorder border(Color? c, [double w = 1.5]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              c == null ? BorderSide.none : BorderSide(color: c, width: w),
        );
    return InputDecoration(
      hintText: hint,
      hintStyle: SplgType.of(context)
          .body
          .copyWith(color: brasa.primaryStrong.withValues(alpha: 0.75)),
      filled: true,
      fillColor: fill ?? scheme.primary.withValues(alpha: 0.1),
      isDense: true,
      contentPadding: EdgeInsets.all(context.sp(11)),
      suffixIcon: suffixIcon,
      prefixIcon: prefix,
      prefixIconConstraints: const BoxConstraints(),
      enabledBorder: border(borderColor, borderWidth),
      disabledBorder: border(null),
      focusedBorder: border(borderColor ?? scheme.primary, borderWidth),
      errorBorder: border(brasa.danger, borderWidth),
      focusedErrorBorder: border(brasa.danger, borderWidth),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      autofillHints: autofillHints,
      inputFormatters: inputFormatters,
      autocorrect: false,
      enableSuggestions: !obscure,
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
