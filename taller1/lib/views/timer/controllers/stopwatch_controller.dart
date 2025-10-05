import 'dart:async';
import 'package:flutter/material.dart';
import '../models/stopwatch_model.dart';

/// Controlador que maneja la lógica del cronómetro
class StopwatchController {
  Timer? _timer;
  StopwatchModel _model = StopwatchModel.stopped();
  
  // Callback que se ejecuta cuando el modelo cambia
  void Function(StopwatchModel)? onModelChanged;

  StopwatchController({this.onModelChanged});

  /// Obtiene el modelo actual
  StopwatchModel get model => _model;

  /// Actualiza el modelo y notifica el cambio
  void _updateModel(StopwatchModel newModel) {
    print('🔄 StopwatchController: Estado cambió de ${_model.state} a ${newModel.state}');
    print('⏱️ StopwatchController: Tiempo actual -> ${newModel.formattedTime}');
    
    _model = newModel;
    onModelChanged?.call(_model);
  }

  /// Inicia el cronómetro
  void start() {
    print('\n🚀 StopwatchController: Iniciando cronómetro...');
    
    if (_model.isRunning) {
      print('⚠️ StopwatchController: El cronómetro ya está corriendo');
      return;
    }

    final now = DateTime.now();
    Duration initialElapsed = _model.elapsed;

    // Si estamos reanudando, mantenemos el tiempo acumulado
    if (_model.isPaused) {
      print('▶️ StopwatchController: Reanudando desde ${_model.formattedTime}');
    } else {
      print('🆕 StopwatchController: Inicio desde cero');
      initialElapsed = Duration.zero;
    }

    _updateModel(StopwatchModel.running(
      elapsed: initialElapsed,
      startTime: now,
    ));

    // Crear timer que se actualiza cada 100ms para mayor precisión
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final currentTime = DateTime.now();
      final runtimeDuration = currentTime.difference(now);
      final totalElapsed = initialElapsed + runtimeDuration;

      _updateModel(StopwatchModel.running(
        elapsed: totalElapsed,
        startTime: _model.startTime!,
      ));
    });

    print('✅ StopwatchController: Timer iniciado con actualización cada 100ms');
  }

  /// Pausa el cronómetro
  void pause() {
    print('\n⏸️ StopwatchController: Pausando cronómetro...');
    
    if (!_model.isRunning) {
      print('⚠️ StopwatchController: El cronómetro no está corriendo');
      return;
    }

    _cancelTimer();

    final now = DateTime.now();
    _updateModel(StopwatchModel.paused(
      elapsed: _model.elapsed,
      startTime: _model.startTime!,
      lastPauseTime: now,
    ));

    print('✅ StopwatchController: Cronómetro pausado en ${_model.formattedTime}');
  }

  /// Reinicia el cronómetro (vuelve a 00:00:00 y se detiene)
  void reset() {
    print('\n🔄 StopwatchController: Reiniciando cronómetro...');
    
    _cancelTimer();
    _updateModel(StopwatchModel.stopped());
    
    print('✅ StopwatchController: Cronómetro reiniciado a 00:00:00');
  }

  /// Cancela el timer si existe
  void _cancelTimer() {
    if (_timer != null) {
      print('🛑 StopwatchController: Cancelando timer');
      _timer!.cancel();
      _timer = null;
    }
  }

  /// Obtiene información de depuración
  Map<String, dynamic> get debugInfo => {
    'state': _model.state.toString(),
    'elapsed': _model.formattedTime,
    'hasTimer': _timer != null,
    'timerIsActive': _timer?.isActive ?? false,
    'canStart': _model.canStart,
    'canPause': _model.canPause,
    'canReset': _model.canReset,
  };

  /// Imprime información de depuración
  void printDebugInfo() {
    print('🔍 StopwatchController Debug Info:');
    debugInfo.forEach((key, value) {
      print('   $key: $value');
    });
  }

  /// Limpia los recursos (IMPORTANTE: llamar en dispose)
  void dispose() {
    print('\n🗑️ StopwatchController: Limpiando recursos...');
    _cancelTimer();
    onModelChanged = null;
    print('✅ StopwatchController: Recursos limpiados correctamente');
  }

  /// Maneja el ciclo de vida de la aplicación
  void handleAppLifecycleState(AppLifecycleState state) {
    print('📱 StopwatchController: App lifecycle cambió a $state');
    
    switch (state) {
      case AppLifecycleState.paused:
        // La app va a segundo plano, pausamos si está corriendo
        if (_model.isRunning) {
          print('⏸️ StopwatchController: Auto-pausando por lifecycle');
          pause();
        }
        break;
      case AppLifecycleState.resumed:
        print('▶️ StopwatchController: App reanudada');
        break;
      case AppLifecycleState.detached:
        // La app se está cerrando, limpiamos recursos
        print('🔚 StopwatchController: App detached, limpiando recursos');
        dispose();
        break;
      default:
        break;
    }
  }
}