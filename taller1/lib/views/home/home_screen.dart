import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _title = 'Dashboard Principal';

  void _toggleTitle() {
    setState(() {
      _title = _title == 'Dashboard Principal'
          ? '¡Título cambiado!'
          : 'Dashboard Principal';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Banner con nombre y avatar
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                        'https://picsum.photos/200',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'ANGIE TATIANA CARDENAS QUINTERO',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Estudiante UCEVA',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botón para cambiar el título
            ElevatedButton.icon(
              onPressed: _toggleTitle,
              icon: const Icon(Icons.edit),
              label: const Text('Cambiar título'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Grid de navegación
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _DashboardCard(
                  icon: Icons.compare_arrows,
                  color: Colors.blue,
                  title: 'Paso de Parámetros',
                  onTap: () => context.push('/paso_parametros'),
                ),
                _DashboardCard(
                  icon: Icons.cyclone,
                  color: Colors.green,
                  title: 'Ciclo de Vida',
                  onTap: () => context.push('/ciclo_vida'),
                ),
                _DashboardCard(
                  icon: Icons.widgets,
                  color: Colors.purple,
                  title: 'Demo de Widgets',
                  onTap: () => context.push('/widgets_demo'),
                ),
                _DashboardCard(
                  icon: Icons.info_outline,
                  color: Colors.orange,
                  title: 'Más info',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Acción secundaria')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Sección de imágenes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1),
                  ),
                  child: Image.network(
                    'https://picsum.photos/120',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(width: 1),
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Lista rápida
            const Text(
              'Recursos rápidos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ListTile(
                  leading: Icon(Icons.phone_android),
                  title: Text('Flutter básico'),
                ),
                ListTile(
                  leading: Icon(Icons.bug_report),
                  title: Text('Depuración'),
                ),
                ListTile(
                  leading: Icon(Icons.cloud_upload),
                  title: Text('Despliegue'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget para las tarjetas del dashboard
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
