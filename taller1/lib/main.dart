import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'themes/app_theme.dart'; // Importar el tema

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //go_router para navegacion
    return MaterialApp.router(
      theme:
          AppTheme.lightTheme, //thema personalizado y permamente en toda la app
      title:
          'Principal - UCEVA', // Usa el tema personalizado, no se muestra el tema por defecto. esto se visualiza en toda la app
      routerConfig: appRouter, // Usa el router configurado
    );
  }
}
