import 'package:flutter/material.dart';

import '../theme/splg_gradients.dart';
import '../theme/splg_type.dart';
import 'splg_illustration.dart';

/// "¡Ganaste! $15.192" sobre el mapa al terminar un pedido: ilustración a la
/// izquierda, monto a la derecha, esquinas inferiores curvas.
class SplgEarnedBanner extends StatelessWidget {
  const SplgEarnedBanner({
    super.key,
    required this.amount,
    this.title = '¡Ganaste!',
  });

  final String amount;
  final String title;

  @override
  Widget build(BuildContext context) {
    final type = SplgType.of(context);
    return Container(
      key: const Key('earned-banner'),
      padding: EdgeInsets.fromLTRB(
          16, MediaQuery.paddingOf(context).top + 8, 20, 18),
      decoration: const BoxDecoration(
        gradient: SplgGradients.button,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
              color: Colors.black26, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          SplgIllustration.success.image(height: 78),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(title, style: type.body.copyWith(color: Colors.white)),
              Text(amount, style: type.title.copyWith(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }
}
