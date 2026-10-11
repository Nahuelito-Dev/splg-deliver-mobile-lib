import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Texto de la licencia de la tipografía Geist (SIL Open Font License 1.1).
/// Viaja como asset de la lib y se registra para que aparezca en la pantalla
/// de licencias de Flutter (`showLicensePage`).
const String geistLicenseAsset = 'packages/splg_lib/fonts/geist/OFL.txt';

bool _registered = false;

/// Registra la licencia de Geist. Se llama una vez en el `main` de cada app.
/// Idempotente. `bundle` es sólo para tests.
void registerSplgLicenses({AssetBundle? bundle}) {
  if (_registered && bundle == null) return;
  _registered = true;
  LicenseRegistry.addLicense(() async* {
    final text = await (bundle ?? rootBundle).loadString(geistLicenseAsset);
    yield LicenseEntryWithLineBreaks(const ['Geist (tipografía)'], text);
  });
}

@visibleForTesting
void resetSplgLicensesForTest() => _registered = false;
