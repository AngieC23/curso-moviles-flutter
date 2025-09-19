import 'package:flutter/material.dart';

class AppTheme {
  //! tema claro
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.pinkAccent, // Rosa claro
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.pinkAccent, // Fondo rosa claro
        foregroundColor: Colors.white, // Texto e iconos blancos
        elevation: 4,
      ),
      useMaterial3: true,
    );
  }
}
