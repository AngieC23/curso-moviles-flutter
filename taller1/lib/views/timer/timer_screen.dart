import 'package:flutter/material.dart';
import '../../widgets/base_view.dart';
import 'controllers/stopwatch_controller.dart';
import 'models/stopwatch_model.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> with WidgetsBindingObserver {
  late StopwatchController _controller;
  StopwatchModel _currentModel = StopwatchModel.stopped();

  @override
  void initState() {
    super.initState();
    print('🎬 TimerScreen: initState() - Inicializando cronómetro');
    
    // Inicializar el controlador
    _controller = StopwatchController(
      onModelChanged: (model) {
        if (mounted) {
          setState(() {
            _currentModel = model;
          });
        }
      },
    );

    // Escuchar cambios del ciclo de vida de la app
    WidgetsBinding.instance.addObserver(this);
    
    print('✅ TimerScreen: Controlador inicializado');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _controller.handleAppLifecycleState(state);
  }

  void _startTimer() {
    print('\n👆 Usuario presionó INICIAR/REANUDAR');
    _controller.start();
  }

  void _pauseTimer() {
    print('\n👆 Usuario presionó PAUSAR');
    _controller.pause();
  }

  void _resetTimer() {
    print('\n👆 Usuario presionó REINICIAR');
    _controller.reset();
  }

  void _debugInfo() {
    print('\n👆 Usuario solicitó información de depuración');
    _controller.printDebugInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Cronómetro - Timer Demo',
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Información del demo
            Card(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '⏱️ Demo de Timer en Flutter',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Timer.periodic actualiza cada 100ms\n'
                      '• Manejo completo de estados: parado/corriendo/pausado\n'
                      '• Limpieza automática de recursos\n'
                      '• Revisa la consola para logs detallados',
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Display principal del tiempo - GRANDE y llamativo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getDisplayBorderColor(),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _getDisplayBorderColor().withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Estado actual
                  Text(
                    _getStateLabel(),
                    style: TextStyle(
                      color: _getDisplayBorderColor(),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Tiempo principal
                  Text(
                    _currentModel.formattedTime,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                      letterSpacing: 2,
                    ),
                  ),
                  
                  // Tiempo simple (solo minutos:segundos)
                  const SizedBox(height: 4),
                  Text(
                    'Simple: ${_currentModel.simpleFormattedTime}',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Botones de control
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botón Iniciar/Reanudar
                _buildControlButton(
                  onPressed: _currentModel.canStart ? _startTimer : null,
                  backgroundColor: Colors.green,
                  icon: _currentModel.isStopped ? Icons.play_arrow : Icons.play_arrow,
                  label: _currentModel.isStopped ? 'INICIAR' : 'REANUDAR',
                ),

                // Botón Pausar
                _buildControlButton(
                  onPressed: _currentModel.canPause ? _pauseTimer : null,
                  backgroundColor: Colors.orange,
                  icon: Icons.pause,
                  label: 'PAUSAR',
                ),

                // Botón Reiniciar
                _buildControlButton(
                  onPressed: _currentModel.canReset ? _resetTimer : null,
                  backgroundColor: Colors.red,
                  icon: Icons.stop,
                  label: 'REINICIAR',
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Información de estado y debug
            Card(
              color: Colors.grey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 18),
                        const SizedBox(width: 8),
                        const Text(
                          'Estado del cronómetro:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        ElevatedButton.icon(
                          onPressed: _debugInfo,
                          icon: const Icon(Icons.bug_report, size: 16),
                          label: const Text('Debug'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 32),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow('Estado:', _currentModel.state.toString().split('.').last),
                    _buildInfoRow('Tiempo transcurrido:', _currentModel.formattedTime),
                    _buildInfoRow('Puede iniciar:', _currentModel.canStart ? 'Sí' : 'No'),
                    _buildInfoRow('Puede pausar:', _currentModel.canPause ? 'Sí' : 'No'),
                    _buildInfoRow('Puede reiniciar:', _currentModel.canReset ? 'Sí' : 'No'),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Nota sobre limpieza de recursos
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.cleaning_services, color: Colors.amber.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Los recursos del Timer se limpian automáticamente al salir o pausar la app',
                      style: TextStyle(
                        color: Colors.amber.shade800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye un botón de control
  Widget _buildControlButton({
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required IconData icon,
    required String label,
  }) {
    final isEnabled = onPressed != null;
    
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24),
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isEnabled ? backgroundColor : Colors.grey.shade300,
        foregroundColor: isEnabled ? Colors.white : Colors.grey.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: isEnabled ? 4 : 0,
      ),
    );
  }

  /// Construye una fila de información
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  /// Obtiene el color del borde del display según el estado
  Color _getDisplayBorderColor() {
    switch (_currentModel.state) {
      case TimerState.running:
        return Colors.green;
      case TimerState.paused:
        return Colors.orange;
      case TimerState.stopped:
        return Colors.grey;
    }
  }

  /// Obtiene la etiqueta del estado actual
  String _getStateLabel() {
    switch (_currentModel.state) {
      case TimerState.running:
        return '🟢 CORRIENDO';
      case TimerState.paused:
        return '🟡 PAUSADO';
      case TimerState.stopped:
        return '⚫ DETENIDO';
    }
  }

  @override
  void dispose() {
    print('🗑️ TimerScreen: dispose() - Limpiando recursos de la pantalla');
    
    // Remover observer del ciclo de vida
    WidgetsBinding.instance.removeObserver(this);
    
    // Limpiar el controlador (esto cancela el Timer)
    _controller.dispose();
    
    print('✅ TimerScreen: Recursos limpiados correctamente');
    super.dispose();
  }
}