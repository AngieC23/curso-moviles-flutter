import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class WidgetsDemoScreen extends StatelessWidget {
  const WidgetsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Demo de Widgets'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.grid_on), text: 'GridView'),
              Tab(icon: Icon(Icons.list), text: 'ListView'),
            ],
          ),
        ),
        drawer: const CustomDrawer(),
        body: TabBarView(
          children: [
            // Tab 1: GridView
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Ejemplo de GridView'),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: const [
                        Card(child: Center(child: Text('A'))),
                        Card(child: Center(child: Text('B'))),
                        Card(child: Center(child: Text('C'))),
                        Card(child: Center(child: Text('D'))),
                        Card(child: Center(child: Text('E'))),
                        Card(child: Center(child: Text('F'))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Tab 2: ListView
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: const [
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Elemento 1'),
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Elemento 2'),
                  ),
                  ListTile(
                    leading: Icon(Icons.star),
                    title: Text('Elemento 3'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
