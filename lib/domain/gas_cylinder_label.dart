import 'package:splg_lib/domain/gas_cylinder.dart';

extension GasCylinderLabel on GasCylinder {
  /// Nombre para mostrar: el catálogo ya trae tipos como "Garrafa 10kg", así
  /// que sólo se antepone "Garrafa" cuando el tipo no lo incluye.
  String get label {
    final t = type.trim();
    return t.toLowerCase().startsWith('garrafa') ? t : 'Garrafa $t';
  }
}
