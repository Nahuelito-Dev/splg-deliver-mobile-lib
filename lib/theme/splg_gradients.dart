import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Degradés verticales de las pantallas (de arriba hacia abajo).
class SplgGradients {
  SplgGradients._();

  /// Botón principal. Mismos extremos que el botón del panel (texto blanco AA).
  static const LinearGradient button = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.primaryGradientFrom, AppColors.primaryGradientTo],
  );

  /// Fondo del menú lateral, notificaciones y cierre de sesión.
  static const LinearGradient surface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.llama700, AppColors.llama900],
  );

  /// Fondo de la pantalla de arranque.
  static const LinearGradient splash = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.llama400, AppColors.llama600, AppColors.llama700],
  );

  /// Barras del gráfico.
  static const LinearGradient bar = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.llama400, AppColors.llama600],
  );
}
