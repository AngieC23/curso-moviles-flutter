import 'dart:math';

/// Servicio simulado para consultas de datos con Future.delayed
class DataService {
  static final Random _random = Random();

  /// Simula una consulta exitosa de datos de usuarios
  static Future<List<String>> obtenerUsuarios() async {
    print('🔄 DataService: Iniciando consulta de usuarios...');
    
    // Simula delay de red (2-3 segundos)
    final delay = Duration(seconds: 2 + _random.nextInt(2)); // 2-3 segundos
    print('⏱️ DataService: Esperando ${delay.inSeconds} segundos...');
    
    await Future.delayed(delay);
    
    print('✅ DataService: Consulta de usuarios completada exitosamente');
    
    return [
      'Juan Pérez',
      'Ana García',
      'Carlos López',
      'María Rodríguez',
      'Pedro Martínez',
      'Sofia González',
      'Luis Hernández',
      'Laura Díaz',
    ];
  }

  /// Simula una consulta que puede fallar aleatoriamente
  static Future<List<String>> obtenerProductos() async {
    print('🔄 DataService: Iniciando consulta de productos...');
    
    final delay = Duration(seconds: 2 + _random.nextInt(2));
    print('⏱️ DataService: Esperando ${delay.inSeconds} segundos...');
    
    await Future.delayed(delay);
    
    // 30% de probabilidad de error
    if (_random.nextDouble() < 0.3) {
      print('❌ DataService: Error en la consulta de productos');
      throw Exception('Error de conexión: No se pudieron obtener los productos');
    }
    
    print('✅ DataService: Consulta de productos completada exitosamente');
    
    return [
      'Laptop HP',
      'Mouse Logitech',
      'Teclado Mecánico',
      'Monitor Samsung',
      'Audífonos Sony',
      'Webcam Logitech',
    ];
  }

  /// Simula una consulta que siempre falla
  static Future<List<String>> obtenerDatosConError() async {
    print('🔄 DataService: Iniciando consulta que fallará...');
    
    final delay = Duration(seconds: 1 + _random.nextInt(2));
    print('⏱️ DataService: Esperando ${delay.inSeconds} segundos antes del error...');
    
    await Future.delayed(delay);
    
    print('❌ DataService: Error simulado generado');
    throw Exception('Error simulado: El servidor no está disponible');
  }

  /// Simula múltiples consultas concurrentes
  static Future<Map<String, List<String>>> obtenerTodosLosDatos() async {
    print('🔄 DataService: Iniciando múltiples consultas concurrentes...');
    
    try {
      // Ejecuta múltiples futures en paralelo
      final results = await Future.wait([
        obtenerUsuarios(),
        obtenerProductos(),
      ]);
      
      print('✅ DataService: Todas las consultas completadas exitosamente');
      
      return {
        'usuarios': results[0],
        'productos': results[1],
      };
    } catch (e) {
      print('❌ DataService: Error en consultas concurrentes: $e');
      rethrow;
    }
  }
}