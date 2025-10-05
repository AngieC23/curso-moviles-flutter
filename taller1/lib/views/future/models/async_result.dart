/// Estados posibles para operaciones asíncronas
enum AsyncState {
  idle,     // Estado inicial
  loading,  // Cargando datos
  success,  // Datos cargados exitosamente
  error,    // Error en la carga
}

/// Clase genérica para manejar el estado de una operación asíncrona
class AsyncResult<T> {
  final AsyncState state;
  final T? data;
  final String? error;
  final DateTime? timestamp;

  const AsyncResult({
    required this.state,
    this.data,
    this.error,
    this.timestamp,
  });

  /// Constructor para estado inicial
  AsyncResult.idle() : 
    state = AsyncState.idle,
    data = null,
    error = null,
    timestamp = null;

  /// Constructor para estado de carga
  AsyncResult.loading() : 
    state = AsyncState.loading,
    data = null,
    error = null,
    timestamp = DateTime.now();

  /// Constructor para estado exitoso
  AsyncResult.success(T data) : 
    state = AsyncState.success,
    data = data,
    error = null,
    timestamp = DateTime.now();

  /// Constructor para estado de error
  AsyncResult.error(String error) : 
    state = AsyncState.error,
    data = null,
    error = error,
    timestamp = DateTime.now();

  /// Getters útiles
  bool get isIdle => state == AsyncState.idle;
  bool get isLoading => state == AsyncState.loading;
  bool get isSuccess => state == AsyncState.success;
  bool get isError => state == AsyncState.error;
  bool get hasData => data != null;

  @override
  String toString() {
    return 'AsyncResult{state: $state, hasData: $hasData, error: $error}';
  }
}