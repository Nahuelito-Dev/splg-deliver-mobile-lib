import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';
import '../theme/splg_gradients.dart';
import '../theme/splg_type.dart';

/// Gráfico de barras en tarjeta con borde de marca: título, subtítulo, eje de
/// importes abreviados y una barra por valor. La última se resalta.
class SplgBarChartCard extends StatelessWidget {
  const SplgBarChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.values,
    required this.labels,
    this.highlight,
    this.infoMessage,
  });

  final String title;
  final String subtitle;
  final List<num> values;
  final List<String> labels;

  /// Barra resaltada; por defecto la última.
  final int? highlight;

  /// Si se pasa, aparece el ícono de información con este texto.
  final String? infoMessage;

  static String abbreviate(num v) {
    if (v >= 1000000) {
      return '${(v / 1000000).toStringAsFixed(v % 1000000 == 0 ? 0 : 1)}M';
    }
    if (v >= 1000) {
      return '${(v / 1000).toStringAsFixed(v % 1000 == 0 ? 0 : 1)}k';
    }
    return v.toStringAsFixed(0);
  }

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final type = SplgType.of(context);
    final max = values.fold<num>(0, (m, v) => v > m ? v : m);
    final top = max == 0 ? 1 : max;
    final hi = highlight ?? values.length - 1;
    const chartHeight = 130.0;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border:
            Border.all(color: Theme.of(context).colorScheme.primary, width: 3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: type.subtitle),
                    Text(subtitle, style: type.captionStrong),
                  ],
                ),
              ),
              if (infoMessage != null)
                Tooltip(
                  message: infoMessage!,
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(SplgIcons.info,
                      size: 22, color: brasa.primaryStrong),
                ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: chartHeight + 36,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 34,
                  height: chartHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final f in [1.0, 0.75, 0.5, 0.25, 0.0])
                        Text(abbreviate(max * f),
                            style: type.captionStrong.copyWith(fontSize: 9)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      SizedBox(
                        height: chartHeight,
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var i = 0; i < 5; i++)
                                  Divider(
                                      height: 1,
                                      color: brasa.primaryStrong
                                          .withValues(alpha: 0.15)),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                for (var i = 0; i < values.length; i++)
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: OverflowBox(
                                        alignment: Alignment.bottomCenter,
                                        minHeight: 0,
                                        maxHeight: chartHeight + 40,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (i == hi && values[i] > 0)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 3),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 1),
                                                decoration: BoxDecoration(
                                                  color: brasa.accentSoft,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                    abbreviate(values[i]),
                                                    style: type.captionStrong
                                                        .copyWith(
                                                            fontSize: 9,
                                                            color: brasa
                                                                .onAccent)),
                                              ),
                                            Container(
                                              width: 22,
                                              height: values[i] == 0
                                                  ? 3
                                                  : 3 +
                                                      (chartHeight - 3) *
                                                          (values[i] / top),
                                              decoration: BoxDecoration(
                                                gradient: i == hi
                                                    ? null
                                                    : SplgGradients.bar,
                                                color: i == hi
                                                    ? brasa.accent
                                                    : null,
                                                borderRadius: const BorderRadius
                                                    .vertical(
                                                    top: Radius.circular(12)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          for (final l in labels)
                            Expanded(
                                child: Text(l,
                                    textAlign: TextAlign.center,
                                    style: type.captionStrong)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
