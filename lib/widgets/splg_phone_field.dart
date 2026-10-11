import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';
import 'splg_text_field.dart';

/// Campo de teléfono argentino con el prefijo +54 fijo. El back pide formato
/// E.164: [toE164] arma el valor a enviar.
class SplgPhoneField extends StatelessWidget {
  const SplgPhoneField({
    super.key,
    required this.controller,
    this.errorText,
    this.enabled = true,
    this.onChanged,
    this.hint = 'Número de teléfono',
  });

  final TextEditingController controller;
  final String? errorText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final String hint;

  /// "(+54) 11 5555-1234", "5411..." o "11 5555 1234" -> "+541155551234".
  static String toE164(String input) {
    var d = input.replaceAll(RegExp(r'[^\d+]'), '');
    if (d.startsWith('+54')) {
      d = d.substring(3);
    } else if (d.startsWith('54') && d.length > 10) {
      d = d.substring(2);
    }
    d = d.replaceAll('+', '');
    return '+54$d';
  }

  /// Entre 8 y 11 dígitos después del +54.
  static bool isValid(String input) =>
      RegExp(r'^\+54\d{8,11}$').hasMatch(toE164(input));

  @override
  Widget build(BuildContext context) {
    return SplgTextField(
      controller: controller,
      enabled: enabled,
      hint: hint,
      errorText: errorText,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d\s+\-()]'))
      ],
      prefix: Padding(
        padding: const EdgeInsets.only(left: 14, right: 8),
        child: Text('+54',
            style: SplgType.of(context)
                .value
                .copyWith(color: context.brasa.primaryStrong)),
      ),
    );
  }
}
