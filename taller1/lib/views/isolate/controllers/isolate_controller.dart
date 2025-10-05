import 'dart:isolate';
import 'dart:async';
import '../services/heavy_tasks.dart';

/// Estados posibles de una tarea
enum TaskState {
  idle,
  running,
  completed,
  error,
}

/// Información de una tarea ejecutándose
class TaskInfo {
  final String id;
  final String name;
  final String description;
  final TaskState state;
  final DateTime? startTime;
  final Duration? executionTime;
  final dynamic result;
  final String? error;

  TaskInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.state,
    this.startTime,
    this.executionTime,
    this.result,
    this.error,
  });

  TaskInfo copyWith({
    String? id,
    String? name,
    String? description,
    TaskState? state,
    DateTime? startTime,
    Duration? executionTime,
    dynamic result,
    String? error,
  }) {
    return TaskInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      state: state ?? this.state,
      startTime: startTime ?? this.startTime,
      executionTime: executionTime ?? this.executionTime,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }

  bool get isIdle => state == TaskState.idle;
  bool get isRunning => state == TaskState.running;
  bool get isCompleted => state == TaskState.completed;
  bool get isError => state == TaskState.error;
  bool get hasResult => result != null;

  String get statusText {
    switch (state) {
      case TaskState.idle:
        return 'Preparada';
      case TaskState.running:
        return 'Ejecutando...';
      case TaskState.completed:
        return 'Completada';
      case TaskState.error:
        return 'Error';
    }
  }

  String get executionTimeText {
    if (executionTime == null) return '--';
    if (executionTime!.inSeconds > 0) {
      return '${executionTime!.inSeconds}.${executionTime!.inMilliseconds % 1000}s';
    }
    return '${executionTime!.inMilliseconds}ms';
  }
}

/// Controlador que maneja múltiples isolates
class IsolateController {
  final Map<String, TaskInfo> _tasks = {};
  final Map<String, Isolate> _isolates = {};
  final Map<String, SendPort> _sendPorts = {};
  
  // Callback para notificar cambios
  void Function(List<TaskInfo>)? onTasksUpdated;

  IsolateController({this.onTasksUpdated});

  /// Obtiene todas las tareas
  List<TaskInfo> get tasks => _tasks.values.toList();

  /// Define las tareas disponibles
  void initializeTasks() {
    print('🚀 IsolateController: Inicializando tareas disponibles...');
    
    _tasks.clear();
    
    final availableTasks = [
      TaskInfo(
        id: 'fibonacci',
        name: 'Fibonacci',
        description: 'Calcula Fibonacci(35) usando recursión',
        state: TaskState.idle,
      ),
      TaskInfo(
        id: 'primes',
        name: 'Números Primos',
        description: 'Encuentra primos hasta 100,000',
        state: TaskState.idle,
      ),
      TaskInfo(
        id: 'bubbleSort',
        name: 'Bubble Sort',
        description: 'Ordena 5,000 números aleatoriamente',
        state: TaskState.idle,
      ),
      TaskInfo(
        id: 'matrix',
        name: 'Matriz Grande',
        description: 'Procesa matriz 200x200 con operaciones complejas',
        state: TaskState.idle,
      ),
      TaskInfo(
        id: 'bigData',
        name: 'Big Data',
        description: 'Genera 50,000 registros JSON',
        state: TaskState.idle,
      ),
    ];

    for (final task in availableTasks) {
      _tasks[task.id] = task;
    }

    print('✅ ${_tasks.length} tareas inicializadas');
    _notifyUpdate();
  }

  /// Ejecuta una tarea en un isolate
  Future<void> runTask(String taskId) async {
    if (!_tasks.containsKey(taskId)) {
      print('❌ Tarea no encontrada: $taskId');
      return;
    }

    final task = _tasks[taskId]!;
    if (task.isRunning) {
      print('⚠️ La tarea $taskId ya está ejecutándose');
      return;
    }

    print('\n🚀 Iniciando tarea: ${task.name}');

    // Actualizar estado a "ejecutando"
    _tasks[taskId] = task.copyWith(
      state: TaskState.running,
      startTime: DateTime.now(),
    );
    _notifyUpdate();

    try {
      // Crear y configurar isolate
      final receivePort = ReceivePort();
      final isolate = await Isolate.spawn(isolateEntryPoint, receivePort.sendPort);
      
      _isolates[taskId] = isolate;
      
      // Obtener SendPort del isolate
      final sendPort = await receivePort.first as SendPort;
      _sendPorts[taskId] = sendPort;

      // Preparar mensaje con parámetros según el tipo de tarea
      final parameters = _getTaskParameters(taskId);
      
      // Crear canal para recibir respuesta
      final responsePort = ReceivePort();
      
      // Enviar mensaje al isolate
      final message = IsolateMessage(
        taskType: taskId,
        parameters: parameters,
        replyPort: responsePort.sendPort,
      );
      
      sendPort.send(message);

      // Esperar respuesta
      final response = await responsePort.first as IsolateResponse;

      // Actualizar tarea con el resultado
      if (response.isSuccess) {
        _tasks[taskId] = task.copyWith(
          state: TaskState.completed,
          executionTime: response.executionTime,
          result: response.result,
        );
        print('✅ Tarea ${task.name} completada en ${response.executionTime.inMilliseconds}ms');
      } else {
        _tasks[taskId] = task.copyWith(
          state: TaskState.error,
          executionTime: response.executionTime,
          error: response.error,
        );
        print('❌ Tarea ${task.name} falló: ${response.error}');
      }

      // Limpiar recursos
      responsePort.close();
      _cleanupIsolate(taskId);

    } catch (e) {
      print('💥 Error ejecutando tarea $taskId: $e');
      
      _tasks[taskId] = task.copyWith(
        state: TaskState.error,
        error: e.toString(),
        executionTime: DateTime.now().difference(task.startTime!),
      );
      
      _cleanupIsolate(taskId);
    }

    _notifyUpdate();
  }

  /// Ejecuta múltiples tareas en paralelo
  Future<void> runMultipleTasks(List<String> taskIds) async {
    print('\n🌐 Ejecutando ${taskIds.length} tareas en paralelo...');
    
    final futures = taskIds.map((taskId) => runTask(taskId)).toList();
    await Future.wait(futures);
    
    print('✅ Todas las tareas paralelas completadas');
  }

  /// Ejecuta todas las tareas disponibles
  Future<void> runAllTasks() async {
    final taskIds = _tasks.keys.toList();
    await runMultipleTasks(taskIds);
  }

  /// Reinicia todas las tareas
  void resetAllTasks() {
    print('🔄 Reiniciando todas las tareas...');
    
    // Limpiar isolates activos
    for (final taskId in _isolates.keys) {
      _cleanupIsolate(taskId);
    }
    
    // Reinicializar tareas
    initializeTasks();
    
    print('✅ Todas las tareas reiniciadas');
  }

  /// Obtiene parámetros específicos para cada tipo de tarea
  Map<String, dynamic> _getTaskParameters(String taskId) {
    switch (taskId) {
      case 'fibonacci':
        return {'n': 35}; // Fibonacci(35) - demora aprox 1-2 segundos
      case 'primes':
        return {'limit': 100000}; // Primos hasta 100,000
      case 'bubbleSort':
        return {'size': 5000}; // 5,000 elementos para ordenar
      case 'matrix':
        return {'size': 200}; // Matriz 200x200
      case 'bigData':
        return {'count': 50000}; // 50,000 registros
      default:
        return {};
    }
  }

  /// Limpia recursos de un isolate
  void _cleanupIsolate(String taskId) {
    if (_isolates.containsKey(taskId)) {
      _isolates[taskId]!.kill(priority: Isolate.immediate);
      _isolates.remove(taskId);
    }
    _sendPorts.remove(taskId);
  }

  /// Notifica cambios a los listeners
  void _notifyUpdate() {
    onTasksUpdated?.call(tasks);
  }

  /// Obtiene estadísticas de rendimiento
  Map<String, dynamic> get performanceStats {
    final completedTasks = tasks.where((task) => task.isCompleted).toList();
    final errorTasks = tasks.where((task) => task.isError).toList();
    final runningTasks = tasks.where((task) => task.isRunning).toList();
    
    final totalExecutionTime = completedTasks.fold<Duration>(
      Duration.zero,
      (sum, task) => sum + (task.executionTime ?? Duration.zero),
    );

    return {
      'totalTasks': tasks.length,
      'completed': completedTasks.length,
      'errors': errorTasks.length,
      'running': runningTasks.length,
      'totalExecutionTime': totalExecutionTime,
      'averageExecutionTime': completedTasks.isNotEmpty 
        ? Duration(milliseconds: totalExecutionTime.inMilliseconds ~/ completedTasks.length)
        : Duration.zero,
    };
  }

  /// Limpia todos los recursos
  void dispose() {
    print('🗑️ IsolateController: Limpiando todos los recursos...');
    
    for (final taskId in _isolates.keys.toList()) {
      _cleanupIsolate(taskId);
    }
    
    _tasks.clear();
    onTasksUpdated = null;
    
    print('✅ IsolateController: Recursos limpiados');
  }
}