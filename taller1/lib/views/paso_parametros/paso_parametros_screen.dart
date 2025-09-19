import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_drawer.dart';

class PasoParametrosScreen extends StatefulWidget {
  const PasoParametrosScreen({super.key});

  @override
  State<PasoParametrosScreen> createState() => _PasoParametrosScreenState();
}

class _PasoParametrosScreenState extends State<PasoParametrosScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paso de Parámetros')),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Ingrese un valor',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final valor = controller.text;
                if (valor.isNotEmpty) {
                  context.go('/detalle/$valor/go');
                }
              },
              child: const Text('Ir con Go'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final valor = controller.text;
                if (valor.isNotEmpty) {
                  context.push('/detalle/$valor/push');
                }
              },
              child: const Text('Ir con Push'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final valor = controller.text;
                if (valor.isNotEmpty) {
                  context.replace('/detalle/$valor/replace');
                }
              },
              child: const Text('Ir con Replace'),
            ),
          ],
        ),
      ),
    );
  }
}
