/// Estados del cronómetro
enum TimerState {
  stopped,  // Cronómetro detenido (tiempo en 00:00:00)
  running,  // Cronómetro corriendo
  paused,   // Cronómetro pausado (mantiene el tiempo actual)
}

/// Modelo del cronómetro que mantiene el estado y tiempo
class StopwatchModel {
  final Duration elapsed;
  final TimerState state;
  final DateTime? startTime;
  final DateTime? lastPauseTime;

  const StopwatchModel({
    required this.elapsed,
    required this.state,
    this.startTime,
    this.lastPauseTime,
  });

  /// Constructor para estado inicial (cronómetro detenido)
  StopwatchModel.stopped() 
    : elapsed = Duration.zero,
      state = TimerState.stopped,
      startTime = null,
      lastPauseTime = null;

  /// Constructor para estado corriendo
  StopwatchModel.running({
    required this.elapsed,
    required this.startTime,
  }) : state = TimerState.running,
       lastPauseTime = null;

  /// Constructor para estado pausado
  StopwatchModel.paused({
    required this.elapsed,
    required this.startTime,
    required this.lastPauseTime,
  }) : state = TimerState.paused;

  /// Getters útiles
  bool get isRunning => state == TimerState.running;
  bool get isPaused => state == TimerState.paused;
  bool get isStopped => state == TimerState.stopped;
  bool get canStart => isStopped || isPaused;
  bool get canPause => isRunning;
  bool get canReset => !isStopped;

  /// Formatea el tiempo en formato HH:MM:SS.mmm
  String get formattedTime {
    final hours = elapsed.inHours;
    final minutes = (elapsed.inMinutes % 60);
    final seconds = (elapsed.inSeconds % 60);
    final milliseconds = (elapsed.inMilliseconds % 1000);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
             '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}.'
             '${(milliseconds ~/ 10).toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}.'
             '${(milliseconds ~/ 10).toString().padLeft(2, '0')}';
    }
  }

  /// Formatea el tiempo para mostrar solo minutos y segundos
  String get simpleFormattedTime {
    final minutes = elapsed.inMinutes;
    final seconds = (elapsed.inSeconds % 60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'StopwatchModel{elapsed: $elapsed, state: $state, formatted: $formattedTime}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StopwatchModel &&
           other.elapsed == elapsed &&
           other.state == state;
  }

  @override
  int get hashCode => elapsed.hashCode ^ state.hashCode;
}