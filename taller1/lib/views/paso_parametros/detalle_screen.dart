import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_drawer.dart';

class DetalleScreen extends StatelessWidget {
  final String parametro;
  final String metodoNavegacion;

  const DetalleScreen({
    super.key,
    required this.parametro,
    required this.metodoNavegacion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      drawer: const CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Parámetro recibido: $parametro'),
            Text('Método de navegación: $metodoNavegacion'),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver al Dashboard'),
              onPressed: () {
                // Regresa al dashboard usando go_router
                context.go('/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
