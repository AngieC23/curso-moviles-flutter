import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';
import 'controllers/isolate_controller.dart';

class IsolateAdvancedScreen extends StatefulWidget {
  const IsolateAdvancedScreen({super.key});

  @override
  State<IsolateAdvancedScreen> createState() => _IsolateAdvancedScreenState();
}

class _IsolateAdvancedScreenState extends State<IsolateAdvancedScreen> {
  late IsolateController _controller;
  List<TaskInfo> _tasks = [];
  bool _isRunningMultiple = false;

  @override
  void initState() {
    super.initState();
    print('🎬 IsolateAdvancedScreen: Inicializando...');
    
    _controller = IsolateController(
      onTasksUpdated: (tasks) {
        if (mounted) {
          setState(() {
            _tasks = tasks;
            _isRunningMultiple = tasks.any((task) => task.isRunning);
          });
        }
      },
    );
    
    _controller.initializeTasks();
    print('✅ IsolateAdvancedScreen: Controlador configurado');
  }

  void _runTask(String taskId) {
    print('👆 Usuario ejecutó tarea: $taskId');
    _controller.runTask(taskId);
  }

  void _runAllTasks() {
    print('👆 Usuario ejecutó TODAS las tareas en paralelo');
    _controller.runAllTasks();
  }

  void _resetAllTasks() {
    print('👆 Usuario reinició todas las tareas');
    _controller.resetAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _controller.performanceStats;
    
    return BaseView(
      title: 'Isolates - Tareas Pesadas',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Información del demo
            Card(
              color: Colors.purple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '🔀 Demo de Isolates en Flutter',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple.shade800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Cada tarea se ejecuta en un Isolate separado\n'
                      '• No bloquea el hilo principal (UI)\n'
                      '• Comunicación por SendPort/ReceivePort\n'
                      '• Múltiples isolates pueden correr en paralelo\n'
                      '• Revisa la consola para logs detallados',
                      style: TextStyle(fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Estadísticas generales
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.analytics, color: Colors.blue),
                        const SizedBox(width: 8),
                        const Text(
                          'Estadísticas de Rendimiento',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            'Completadas',
                            '${stats['completed']}/${stats['totalTasks']}',
                            Colors.green,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            'Ejecutando',
                            '${stats['running']}',
                            Colors.orange,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            'Errores',
                            '${stats['errors']}',
                            Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            'Tiempo Total',
                            _formatDuration(stats['totalExecutionTime']),
                            Colors.purple,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            'Promedio',
                            _formatDuration(stats['averageExecutionTime']),
                            Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Botones de control global
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isRunningMultiple ? null : _runAllTasks,
                    icon: const Icon(Icons.play_circle_filled),
                    label: const Text('Ejecutar Todo en Paralelo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _resetAllTasks,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reiniciar Todo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Lista de tareas
            const Text(
              '🎯 Tareas Disponibles',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            ..._tasks.map((task) => _buildTaskCard(task)),

            const SizedBox(height: 24),

            // Información adicional
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb, color: Colors.amber.shade700),
                        const SizedBox(width: 8),
                        const Text(
                          '💡 ¿Por qué usar Isolates?',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Evitan que la UI se congele durante tareas pesadas\n'
                      '• Permiten paralelismo real en múltiples cores\n'
                      '• Cada isolate tiene su propia memoria (no comparten estado)\n'
                      '• Ideales para: procesamiento de imágenes, cálculos complejos, parsing de JSON grandes',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye una tarjeta para cada tarea
  Widget _buildTaskCard(TaskInfo task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: task.isRunning ? 4 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado de la tarea
            Row(
              children: [
                // Icono de estado
                _buildStatusIcon(task.state),
                const SizedBox(width: 12),
                
                // Información de la tarea
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        task.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Botón de acción
                ElevatedButton(
                  onPressed: task.isRunning ? null : () => _runTask(task.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getTaskColor(task.state),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(80, 36),
                  ),
                  child: task.isRunning 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Ejecutar', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),

            // Información adicional si está disponible
            if (task.state != TaskState.idle) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Estado:', task.statusText),
                    if (task.executionTime != null)
                      _buildInfoRow('Tiempo:', task.executionTimeText),
                    if (task.isCompleted && task.hasResult)
                      _buildResultInfo(task),
                    if (task.isError && task.error != null)
                      _buildInfoRow('Error:', task.error!, isError: true),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Construye información del resultado según el tipo de tarea
  Widget _buildResultInfo(TaskInfo task) {
    String resultText = '';
    
    switch (task.id) {
      case 'fibonacci':
        resultText = 'Resultado: ${task.result}';
        break;
      case 'primes':
        final primes = task.result as List<int>;
        resultText = 'Encontrados: ${primes.length} números primos';
        break;
      case 'bubbleSort':
        final sorted = task.result as List<int>;
        resultText = 'Ordenados: ${sorted.length} elementos';
        break;
      case 'matrix':
        final matrix = task.result as List<List<double>>;
        resultText = 'Procesada matriz: ${matrix.length}x${matrix[0].length}';
        break;
      case 'bigData':
        final data = task.result as List<Map<String, dynamic>>;
        resultText = 'Generados: ${data.length} registros';
        break;
    }
    
    return _buildInfoRow('Resultado:', resultText);
  }

  /// Construye una fila de información
  Widget _buildInfoRow(String label, String value, {bool isError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                color: isError ? Colors.red : Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construye un elemento de estadística
  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  /// Construye el icono de estado
  Widget _buildStatusIcon(TaskState state) {
    switch (state) {
      case TaskState.idle:
        return const Icon(Icons.play_circle_outline, color: Colors.grey);
      case TaskState.running:
        return const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case TaskState.completed:
        return const Icon(Icons.check_circle, color: Colors.green);
      case TaskState.error:
        return const Icon(Icons.error, color: Colors.red);
    }
  }

  /// Obtiene el color según el estado de la tarea
  Color _getTaskColor(TaskState state) {
    switch (state) {
      case TaskState.idle:
        return Colors.blue;
      case TaskState.running:
        return Colors.orange;
      case TaskState.completed:
        return Colors.green;
      case TaskState.error:
        return Colors.red;
    }
  }

  /// Formatea una duración
  String _formatDuration(Duration duration) {
    if (duration.inSeconds > 0) {
      return '${duration.inSeconds}.${(duration.inMilliseconds % 1000).toString().padLeft(3, '0')}s';
    }
    return '${duration.inMilliseconds}ms';
  }

  @override
  void dispose() {
    print('🗑️ IsolateAdvancedScreen: Limpiando recursos...');
    _controller.dispose();
    super.dispose();
  }
}