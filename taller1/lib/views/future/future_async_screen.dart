import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';
import 'models/async_result.dart';
import 'services/data_service.dart';

class FutureAsyncScreen extends StatefulWidget {
  const FutureAsyncScreen({super.key});

  @override
  State<FutureAsyncScreen> createState() => _FutureAsyncScreenState();
}

class _FutureAsyncScreenState extends State<FutureAsyncScreen> {
  // Estados para diferentes tipos de consultas
  AsyncResult<List<String>> _usuariosResult = AsyncResult.idle();
  AsyncResult<List<String>> _productosResult = AsyncResult.idle();
  AsyncResult<List<String>> _errorResult = AsyncResult.idle();
  AsyncResult<Map<String, List<String>>> _concurrentResult = AsyncResult.idle();

  int _operationCounter = 0;

  @override
  void initState() {
    super.initState();
    print('📱 FutureAsyncScreen: initState() - Widget inicializado');
  }

  /// Maneja la consulta de usuarios con async/await
  Future<void> _cargarUsuarios() async {
    final operationId = ++_operationCounter;
    print('\n🚀 [Op-$operationId] ANTES: Iniciando carga de usuarios...');
    print('🔍 [Op-$operationId] Thread principal: ${DateTime.now()}');

    setState(() {
      _usuariosResult = AsyncResult.loading();
      print('🎨 [Op-$operationId] UI actualizada: Estado -> LOADING');
    });

    try {
      print('⏳ [Op-$operationId] DURANTE: Esperando respuesta del servicio...');

      // Aquí async/await NO bloquea la UI
      final usuarios = await DataService.obtenerUsuarios();

      print(
        '📊 [Op-$operationId] Datos recibidos: ${usuarios.length} usuarios',
      );

      if (!mounted) {
        print(
          '⚠️ [Op-$operationId] Widget desmontado, cancelando actualización',
        );
        return;
      }

      setState(() {
        _usuariosResult = AsyncResult.success(usuarios);
        print('✅ [Op-$operationId] UI actualizada: Estado -> SUCCESS');
      });

      print('🎯 [Op-$operationId] DESPUÉS: Operación completada exitosamente');
    } catch (e) {
      print('💥 [Op-$operationId] DURANTE: Error capturado - $e');

      if (!mounted) return;

      setState(() {
        _usuariosResult = AsyncResult.error(e.toString());
        print('❌ [Op-$operationId] UI actualizada: Estado -> ERROR');
      });

      print('🔚 [Op-$operationId] DESPUÉS: Operación terminada con error');
    }

    print('⭐ [Op-$operationId] Método _cargarUsuarios() completado\n');
  }

  /// Maneja la consulta de productos (con posible error)
  Future<void> _cargarProductos() async {
    final operationId = ++_operationCounter;
    print('\n🚀 [Op-$operationId] ANTES: Iniciando carga de productos...');

    setState(() {
      _productosResult = AsyncResult.loading();
    });

    try {
      print('⏳ [Op-$operationId] DURANTE: Consultando productos...');
      final productos = await DataService.obtenerProductos();

      if (!mounted) return;

      setState(() {
        _productosResult = AsyncResult.success(productos);
      });

      print('✅ [Op-$operationId] DESPUÉS: Productos cargados exitosamente');
    } catch (e) {
      print('💥 [Op-$operationId] DURANTE: Error en productos - $e');

      if (!mounted) return;

      setState(() {
        _productosResult = AsyncResult.error(e.toString());
      });

      print('❌ [Op-$operationId] DESPUÉS: Falló la carga de productos');
    }
  }

  /// Simula una consulta que siempre falla
  Future<void> _provocarError() async {
    final operationId = ++_operationCounter;
    print('\n💀 [Op-$operationId] ANTES: Iniciando consulta que fallará...');

    setState(() {
      _errorResult = AsyncResult.loading();
    });

    try {
      print(
        '⏳ [Op-$operationId] DURANTE: Ejecutando consulta destinada al fracaso...',
      );
      final data = await DataService.obtenerDatosConError();

      // Esto nunca se ejecutará
      setState(() {
        _errorResult = AsyncResult.success(data);
      });
    } catch (e) {
      print('🎯 [Op-$operationId] DURANTE: Error esperado capturado - $e');

      if (!mounted) return;

      setState(() {
        _errorResult = AsyncResult.error(e.toString());
      });

      print('✅ [Op-$operationId] DESPUÉS: Error manejado correctamente');
    }
  }

  /// Demuestra consultas concurrentes
  Future<void> _cargarDatosConcurrentes() async {
    final operationId = ++_operationCounter;
    print('\n🌐 [Op-$operationId] ANTES: Iniciando consultas CONCURRENTES...');

    setState(() {
      _concurrentResult = AsyncResult.loading();
    });

    try {
      print(
        '⏳ [Op-$operationId] DURANTE: Ejecutando múltiples futures en paralelo...',
      );
      final datos = await DataService.obtenerTodosLosDatos();

      if (!mounted) return;

      setState(() {
        _concurrentResult = AsyncResult.success(datos);
      });

      print(
        '✅ [Op-$operationId] DESPUÉS: Todas las consultas concurrentes completadas',
      );
    } catch (e) {
      print(
        '💥 [Op-$operationId] DURANTE: Error en consultas concurrentes - $e',
      );

      if (!mounted) return;

      setState(() {
        _concurrentResult = AsyncResult.error(e.toString());
      });

      print('❌ [Op-$operationId] DESPUÉS: Falló alguna consulta concurrente');
    }
  }

  /// Limpia todos los resultados
  void _limpiarResultados() {
    print('\n🧹 Limpiando todos los resultados...');
    setState(() {
      _usuariosResult = AsyncResult.idle();
      _productosResult = AsyncResult.idle();
      _errorResult = AsyncResult.idle();
      _concurrentResult = AsyncResult.idle();
    });
    print('✨ Todos los estados reiniciados\n');
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Future / Async / Await Demo',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Información inicial
            Card(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎯 Demo de Asincronía en Flutter',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Cada botón simula una consulta con Future.delayed (2-3s)\n'
                      '• Usa async/await sin bloquear la UI\n'
                      '• Muestra estados: Cargando / Éxito / Error\n'
                      '• Revisa la consola para ver el orden de ejecución',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _cargarUsuarios,
                    icon: const Icon(Icons.people),
                    label: const Text('Cargar Usuarios'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _cargarProductos,
                    icon: const Icon(Icons.inventory),
                    label: const Text('Cargar Productos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _provocarError,
                    icon: const Icon(Icons.error),
                    label: const Text('Provocar Error'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _cargarDatosConcurrentes,
                    icon: const Icon(Icons.sync),
                    label: const Text('Consultas Concurrentes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            ElevatedButton.icon(
              onPressed: _limpiarResultados,
              icon: const Icon(Icons.clear),
              label: const Text('Limpiar Resultados'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            // Resultados
            _buildResultSection('👥 Usuarios', _usuariosResult),
            _buildResultSection('📦 Productos', _productosResult),
            _buildResultSection('💥 Error Simulado', _errorResult),
            _buildConcurrentResultSection(),
          ],
        ),
      ),
    );
  }

  /// Construye una sección de resultado genérica
  Widget _buildResultSection(String title, AsyncResult<List<String>> result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStateWidget(result),
          ],
        ),
      ),
    );
  }

  /// Construye la sección de resultados concurrentes
  Widget _buildConcurrentResultSection() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🌐 Consultas Concurrentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_concurrentResult.isIdle)
              const Text(
                'Presiona el botón para ejecutar múltiples consultas en paralelo',
              ),
            if (_concurrentResult.isLoading)
              const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 16),
                  Text('Ejecutando múltiples consultas...'),
                ],
              ),
            if (_concurrentResult.isSuccess && _concurrentResult.data != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '✅ Todas las consultas completadas:',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...(_concurrentResult.data!.entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${entry.key.toUpperCase()}:',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          ...entry.value.map((item) => Text('  • $item')),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            if (_concurrentResult.isError)
              Text(
                '❌ Error: ${_concurrentResult.error}',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  /// Construye el widget según el estado
  Widget _buildStateWidget(AsyncResult<List<String>> result) {
    if (result.isIdle) {
      return const Text('Presiona el botón para cargar datos');
    }

    if (result.isLoading) {
      return const Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Text('Cargando...'),
        ],
      );
    }

    if (result.isError) {
      return Text(
        '❌ Error: ${result.error}',
        style: const TextStyle(color: Colors.red),
      );
    }

    if (result.isSuccess && result.hasData) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '✅ Datos cargados (${result.data!.length} elementos):',
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...result.data!.map((item) => Text('• $item')),
        ],
      );
    }

    return const Text('Estado desconocido');
  }

  @override
  void dispose() {
    print('🗑️ FutureAsyncScreen: dispose() - Widget destruido');
    super.dispose();
  }
}
