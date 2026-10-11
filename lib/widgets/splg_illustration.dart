import 'package:flutter/material.dart';

/// Ilustraciones 3D de los estados (3dicons.co, CC0; ver ASSETS_LICENSES.md).
enum SplgIllustration {
  welcome('assets/illustrations/welcome.png'),
  recoverPassword('assets/illustrations/recover_password.png'),
  mailSent('assets/illustrations/mail_sent.png'),
  emptyList('assets/illustrations/empty_deliveries.png'),
  emptyNotifications('assets/illustrations/empty_notifications.png'),
  success('assets/illustrations/success.png'),
  error('assets/illustrations/error.png');

  const SplgIllustration(this.asset);
  final String asset;

  Widget image({double? width, double? height, BoxFit fit = BoxFit.contain}) =>
      ExcludeSemantics(
        child: Image.asset(
          asset,
          package: 'splg_lib',
          width: width,
          height: height,
          fit: fit,
          filterQuality: FilterQuality.medium,
        ),
      );
}
