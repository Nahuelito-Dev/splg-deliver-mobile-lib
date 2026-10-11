import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';

/// Tarjeta tintada (marca al 10 %, radio 20) para cifras destacadas: total del
/// día, importe de una entrega.
class SplgSoftCard extends StatelessWidget {
  const SplgSoftCard({
    super.key,
    required this.label,
    required this.amount,
    this.caption,
    this.amountKey,
  });

  final String label;
  final String amount;
  final String? caption;
  final Key? amountKey;

  @override
  Widget build(BuildContext context) {
    final type = SplgType.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: context.brasa.primaryStrong.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(label,
              style: type.subtitle
                  .copyWith(color: Theme.of(context).colorScheme.primary)),
          const SizedBox(height: 2),
          Text(amount, key: amountKey, style: type.amount),
          if (caption != null)
            Text(caption!, style: type.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
