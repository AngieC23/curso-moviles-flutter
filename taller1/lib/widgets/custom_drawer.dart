import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.school,
                    size: 35,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Flutter UCEVA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Taller Móviles',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Sección de navegación básica
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Navegación Principal',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.compare_arrows, color: Colors.blue),
            title: const Text('Paso de Parámetros'),
            subtitle: const Text('Navegación con datos'),
            onTap: () {
              Navigator.pop(context);
              context.push('/paso_parametros');
            },
          ),
          ListTile(
            leading: const Icon(Icons.cyclone, color: Colors.green),
            title: const Text('Ciclo de Vida'),
            subtitle: const Text('Estados del widget'),
            onTap: () {
              Navigator.pop(context);
              context.push('/ciclo_vida');
            },
          ),
          ListTile(
            leading: const Icon(Icons.widgets, color: Colors.purple),
            title: const Text('Demo de Widgets'),
            subtitle: const Text('Componentes UI'),
            onTap: () {
              Navigator.pop(context);
              context.push('/widgets_demo');
            },
          ),
          const Divider(), // Separador visual
          // Sección de funcionalidades avanzadas
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Funcionalidades Avanzadas',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.schedule, color: Colors.orange),
            title: const Text('Future'),
            subtitle: const Text('Asincronía y estados'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/future_async');
            },
          ),
          ListTile(
            leading: const Icon(Icons.timer, color: Colors.red),
            title: const Text('Timer'),
            subtitle: const Text('Timer y ciclo de vida'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/timer');
            },
          ),
          ListTile(
            leading: const Icon(Icons.psychology, color: Colors.indigo),
            title: const Text('Isolate'),
            subtitle: const Text('Tareas en paralelo'),
            onTap: () {
              Navigator.of(context).pop();
              context.push('/isolate');
            },
          ),
          const Divider(),
          // Información adicional
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Taller de Flutter',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Desarrollo Móvil - UCEVA',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.flutter_dash, size: 16, color: Colors.blue.shade400),
                    const SizedBox(width: 4),
                    Text(
                      'Flutter & Dart',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
