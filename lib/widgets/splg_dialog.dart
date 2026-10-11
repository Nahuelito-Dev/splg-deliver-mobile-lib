import 'package:flutter/material.dart';

import '../theme/splg_gradients.dart';
import '../theme/splg_scale.dart';
import '../theme/splg_type.dart';
import 'splg_button.dart';
import 'splg_illustration.dart';

/// Modal de marca: degradé, ilustración opcional, título, texto y un botón
/// blanco (más uno secundario de contorno si hay `secondaryLabel`).
class SplgDialog extends StatelessWidget {
  const SplgDialog({
    super.key,
    required this.title,
    required this.message,
    required this.primaryLabel,
    this.illustration,
    this.secondaryLabel,
    this.destructive = false,
  });

  final String title;
  final String message;
  final String primaryLabel;
  final String? secondaryLabel;
  final SplgIllustration? illustration;

  /// El botón principal es de peligro (baja de cuenta, cancelar).
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final type = SplgType.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        decoration: BoxDecoration(
          gradient: SplgGradients.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (illustration != null)
                illustration!.image(height: context.sp(60)),
              const SizedBox(height: 8),
              Text(title,
                  textAlign: TextAlign.center,
                  style: type.heading
                      .copyWith(color: Colors.white, fontSize: context.sp(14))),
              const SizedBox(height: 8),
              Text(message,
                  textAlign: TextAlign.center,
                  style: type.body.copyWith(color: Colors.white)),
              const SizedBox(height: 20),
              SplgButton(
                title: primaryLabel,
                style: destructive
                    ? SplgButtonStyle.danger
                    : SplgButtonStyle.white,
                onPressed: () => Navigator.of(context).pop(true),
              ),
              if (secondaryLabel != null) ...[
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(secondaryLabel!,
                      style: type.body.copyWith(color: Colors.white)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Muestra un [SplgDialog]; devuelve `true` si tocó el botón principal.
Future<bool> showSplgDialog(
  BuildContext context, {
  required String title,
  required String message,
  String primaryLabel = 'Aceptar',
  String? secondaryLabel,
  SplgIllustration? illustration,
  bool destructive = false,
}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (_) => SplgDialog(
      title: title,
      message: message,
      primaryLabel: primaryLabel,
      secondaryLabel: secondaryLabel,
      illustration: illustration,
      destructive: destructive,
    ),
  );
  return r == true;
}
