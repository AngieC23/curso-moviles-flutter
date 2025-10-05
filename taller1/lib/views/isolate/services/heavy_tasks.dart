import 'dart:isolate';
import 'dart:math';

/// Clase que contiene diferentes tareas CPU-intensivas
class HeavyTasks {
  
  /// Calcula la secuencia de Fibonacci hasta el número n
  /// Esta es una tarea CPU-intensiva porque usa recursión
  static int calculateFibonacci(int n) {
    print('🔢 Calculando Fibonacci($n) en isolate...');
    if (n <= 1) return n;
    return calculateFibonacci(n - 1) + calculateFibonacci(n - 2);
  }

  /// Encuentra todos los números primos hasta n usando Criba de Eratóstenes
  static List<int> findPrimes(int limit) {
    print('🔍 Buscando números primos hasta $limit en isolate...');
    
    if (limit < 2) return [];
    
    List<bool> isPrime = List.filled(limit + 1, true);
    isPrime[0] = isPrime[1] = false;
    
    for (int i = 2; i * i <= limit; i++) {
      if (isPrime[i]) {
        for (int j = i * i; j <= limit; j += i) {
          isPrime[j] = false;
        }
      }
    }
    
    List<int> primes = [];
    for (int i = 2; i <= limit; i++) {
      if (isPrime[i]) {
        primes.add(i);
      }
    }
    
    print('✅ Encontrados ${primes.length} números primos');
    return primes;
  }

  /// Ordena una lista grande usando bubble sort (ineficiente a propósito)
  static List<int> bubbleSortLargeList(int size) {
    print('📊 Generando y ordenando lista de $size elementos con bubble sort...');
    
    final random = Random();
    List<int> numbers = List.generate(size, (index) => random.nextInt(10000));
    
    print('📋 Lista generada, iniciando ordenamiento...');
    
    // Bubble sort - O(n²) - intencionalmente lento
    for (int i = 0; i < numbers.length - 1; i++) {
      for (int j = 0; j < numbers.length - i - 1; j++) {
        if (numbers[j] > numbers[j + 1]) {
          int temp = numbers[j];
          numbers[j] = numbers[j + 1];
          numbers[j + 1] = temp;
        }
      }
      
      // Log progreso cada 100 iteraciones
      if (i % 100 == 0) {
        print('🔄 Progreso ordenamiento: ${((i / numbers.length) * 100).toStringAsFixed(1)}%');
      }
    }
    
    print('✅ Lista ordenada completamente');
    return numbers;
  }

  /// Simula procesamiento de imagen/matriz grande
  static List<List<double>> processLargeMatrix(int size) {
    print('🧮 Procesando matriz de ${size}x$size elementos...');
    
    final random = Random();
    
    // Crear matriz
    List<List<double>> matrix = List.generate(
      size,
      (i) => List.generate(size, (j) => random.nextDouble() * 100),
    );
    
    // Aplicar transformaciones costosas
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        // Operaciones costosas: trigonometría + logaritmos
        matrix[i][j] = sin(matrix[i][j]) * cos(matrix[i][j]) + 
                       log(matrix[i][j] + 1) * sqrt(matrix[i][j]);
      }
      
      // Log progreso
      if (i % 50 == 0) {
        print('🔄 Procesando matriz: ${((i / size) * 100).toStringAsFixed(1)}%');
      }
    }
    
    print('✅ Matriz procesada');
    return matrix;
  }

  /// Genera una gran cantidad de datos JSON simulados
  static List<Map<String, dynamic>> generateBigData(int count) {
    print('📋 Generando $count registros de datos...');
    
    final random = Random();
    final names = ['Juan', 'María', 'Pedro', 'Ana', 'Carlos', 'Sofía', 'Luis', 'Carmen'];
    final cities = ['Bogotá', 'Medellín', 'Cali', 'Cartagena', 'Bucaramanga', 'Pereira'];
    
    List<Map<String, dynamic>> data = [];
    
    for (int i = 0; i < count; i++) {
      data.add({
        'id': i + 1,
        'name': names[random.nextInt(names.length)],
        'age': 18 + random.nextInt(50),
        'city': cities[random.nextInt(cities.length)],
        'salary': 1000000 + random.nextInt(5000000),
        'score': random.nextDouble() * 100,
        'active': random.nextBool(),
        'timestamp': DateTime.now().millisecondsSinceEpoch + i,
        'metadata': {
          'department': 'IT',
          'level': random.nextInt(5) + 1,
          'projects': List.generate(
            random.nextInt(5) + 1,
            (index) => 'Project_${random.nextInt(100)}',
          ),
        },
      });
      
      // Log progreso cada 1000 registros
      if (i % 1000 == 0 && i > 0) {
        print('🔄 Generando datos: ${((i / count) * 100).toStringAsFixed(1)}%');
      }
    }
    
    print('✅ $count registros generados');
    return data;
  }
}

/// Mensajes que se envían al isolate
class IsolateMessage {
  final String taskType;
  final Map<String, dynamic> parameters;
  final SendPort replyPort;

  IsolateMessage({
    required this.taskType,
    required this.parameters,
    required this.replyPort,
  });
}

/// Respuesta del isolate
class IsolateResponse {
  final String taskType;
  final dynamic result;
  final Duration executionTime;
  final String? error;

  IsolateResponse({
    required this.taskType,
    required this.result,
    required this.executionTime,
    this.error,
  });

  bool get isSuccess => error == null;
  bool get isError => error != null;
}

/// Función principal que ejecuta tareas en el isolate
void isolateEntryPoint(SendPort mainSendPort) async {
  print('🔀 Isolate iniciado, estableciendo comunicación...');
  
  final isolateReceivePort = ReceivePort();
  mainSendPort.send(isolateReceivePort.sendPort);
  
  await for (final message in isolateReceivePort) {
    if (message is IsolateMessage) {
      print('📨 Isolate recibió tarea: ${message.taskType}');
      
      final stopwatch = Stopwatch()..start();
      
      try {
        dynamic result;
        
        switch (message.taskType) {
          case 'fibonacci':
            final n = message.parameters['n'] as int;
            result = HeavyTasks.calculateFibonacci(n);
            break;
            
          case 'primes':
            final limit = message.parameters['limit'] as int;
            result = HeavyTasks.findPrimes(limit);
            break;
            
          case 'bubbleSort':
            final size = message.parameters['size'] as int;
            result = HeavyTasks.bubbleSortLargeList(size);
            break;
            
          case 'matrix':
            final size = message.parameters['size'] as int;
            result = HeavyTasks.processLargeMatrix(size);
            break;
            
          case 'bigData':
            final count = message.parameters['count'] as int;
            result = HeavyTasks.generateBigData(count);
            break;
            
          default:
            throw Exception('Tipo de tarea desconocido: ${message.taskType}');
        }
        
        stopwatch.stop();
        
        final response = IsolateResponse(
          taskType: message.taskType,
          result: result,
          executionTime: stopwatch.elapsed,
        );
        
        print('✅ Tarea ${message.taskType} completada en ${stopwatch.elapsed.inMilliseconds}ms');
        message.replyPort.send(response);
        
      } catch (e) {
        stopwatch.stop();
        
        final response = IsolateResponse(
          taskType: message.taskType,
          result: null,
          executionTime: stopwatch.elapsed,
          error: e.toString(),
        );
        
        print('❌ Error en tarea ${message.taskType}: $e');
        message.replyPort.send(response);
      }
    }
  }
}