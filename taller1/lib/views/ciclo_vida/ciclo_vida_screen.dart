import 'package:flutter/material.dart';
import '../../widgets/custom_drawer.dart';

class CicloVidaScreen extends StatefulWidget {
  const CicloVidaScreen({super.key});

  @override
  State<CicloVidaScreen> createState() => _CicloVidaScreenState();
}

class _CicloVidaScreenState extends State<CicloVidaScreen> {
  String texto = "texto inicial 🟢";

  // Se llama una sola vez cuando el widget se inserta en el árbol.
  // Ideal para inicializar variables, cargar datos, etc.
  @override
  void initState() {
    super.initState();
    print("🟢 initState() -> La pantalla se ha inicializado");
  }

  // Se llama después de initState y cada vez que cambia un InheritedWidget del contexto (ej: tema).
  // Útil para dependencias que pueden cambiar durante la vida del widget.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("🟡 didChangeDependencies() -> Tema actual");
  }

  // Se llama cada vez que el widget se construye (por ejemplo, tras setState).
  // Aquí se define la UI.
  @override
  Widget build(BuildContext context) {
    print("🔵 build() -> Construyendo la pantalla");
    return Scaffold(
      appBar: AppBar(title: const Text('Ciclo de Vida')),
      drawer: const CustomDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(texto),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // setState notifica a Flutter que el estado cambió y debe reconstruir el widget.
                setState(() {
                  texto = "Texto actualizado 🟠";
                  print("🟠 setState() -> Estado actualizado");
                });
              },
              child: const Text('Actualizar texto'),
            ),
          ],
        ),
      ),
    );
  }

  // Se llama cuando el widget se elimina del árbol.
  // Ideal para liberar recursos, cancelar timers, etc.
  @override
  void dispose() {
    print("🔴 dispose() -> La pantalla se ha destruido");
    super.dispose();
  }
}
