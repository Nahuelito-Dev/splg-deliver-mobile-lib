import 'package:flutter/material.dart';

import '../icons/splg_icons.dart';
import '../theme/brasa_palette.dart';

/// Foto de perfil circular con borde de marca; sin foto muestra las iniciales
/// o, si tampoco hay, el ícono de persona.
class SplgAvatar extends StatelessWidget {
  const SplgAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.radius = 40,
  });

  final String? imageUrl;
  final String? initials;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final brasa = context.brasa;
    final fallback = (initials != null && initials!.isNotEmpty)
        ? Text(initials!,
            key: const Key('avatar-initials'),
            style: TextStyle(
                fontSize: radius * 0.6,
                fontWeight: FontWeight.w700,
                color: brasa.primaryStrong))
        : Icon(SplgIcons.user, size: radius, color: brasa.primaryStrong);
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: brasa.primaryStrong, width: 2),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: brasa.primarySoft,
        foregroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
        child: fallback,
      ),
    );
  }
}
