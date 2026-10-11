import 'package:flutter/material.dart';

import '../theme/brasa_palette.dart';
import '../theme/splg_type.dart';
import 'splg_avatar.dart';

/// Cabecera del perfil: avatar, nombre, teléfono y un enlace de acción.
class SplgProfileHeader extends StatelessWidget {
  const SplgProfileHeader({
    super.key,
    required this.name,
    this.phone,
    this.initials,
    this.imageUrl,
    this.caption,
    this.linkLabel,
    this.onLink,
  });

  final String name;
  final String? phone;
  final String? initials;
  final String? imageUrl;

  /// Línea extra ("3 pedidos · 4,8 ★").
  final String? caption;
  final String? linkLabel;
  final VoidCallback? onLink;

  @override
  Widget build(BuildContext context) {
    final type = SplgType.of(context);
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child:
                SplgAvatar(imageUrl: imageUrl, initials: initials, radius: 40),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: type.subtitle.copyWith(color: primary)),
                if (phone != null && phone!.isNotEmpty)
                  Text(phone!,
                      style: type.bodyStrong.copyWith(
                          fontWeight: FontWeight.w400, color: primary)),
                if (caption != null) Text(caption!, style: type.caption),
                if (linkLabel != null)
                  InkWell(
                    onTap: onLink,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(linkLabel!,
                          style: type.captionStrong.copyWith(
                              color: context.brasa.accent == primary
                                  ? primary
                                  : context.brasa.primaryStrong,
                              fontWeight: FontWeight.w700)),
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
