import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'routes/app_router.dart';
import 'themes/app_theme.dart'; // Importar el tema

void main() async {
  // Asegurar que los widgets estén inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno desde .env
  try {
    await dotenv.load(fileName: ".env");
    print('✅ Variables de entorno cargadas correctamente');
  } catch (e) {
    print('⚠️  Error cargando variables de entorno: $e');
    // La app puede continuar sin las variables de entorno
  }
  
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
      debugShowCheckedModeBanner:
          false, // Ocultar banner de debug para capturas
      routerConfig: appRouter, // Usa el router configurado
    );
  }
}
