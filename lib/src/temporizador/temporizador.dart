import 'package:flutter/material.dart';
import 'dart:math' as math;

class Tempor extends StatelessWidget {
  const Tempor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Temporizador de Entrenamiento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF2C3E50),
                Color(0xFF1E2A3A),
              ],
            ),
          ),
          child: const TimerPage(),
        ),
      ),
    );
  }
}

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _totalSeconds = 60;
  int _remainingSeconds = 60;
  bool _isRunning = false;
  bool _isPaused = false;
  String _buttonText = "INICIAR";
  Color _buttonColor = Colors.green;
  final TextEditingController _minutesController = TextEditingController(text: "1");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _minutesController.dispose();
    super.dispose();
  }

  void _setTime() {
    try {
      int minutes = int.tryParse(_minutesController.text) ?? 1;
      // Asegurar que los minutos estén en un rango razonable
      minutes = minutes.clamp(1, 60);
      
      setState(() {
        _totalSeconds = minutes * 60;
        _remainingSeconds = _totalSeconds;
        if (_isRunning) {
          _resetTimer();
        }
      });
    } catch (e) {
      print("Error al configurar el tiempo: $e");
    }
  }

  void _startTimer() {
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _buttonText = "PAUSAR";
      _buttonColor = Colors.orange;
    });
    
    // Usar un ticker básico en lugar de animación compleja
    Future.doWhile(() async {
      if (!_isRunning || _isPaused) return false;
      
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          }
          
          if (_remainingSeconds <= 0) {
            _isRunning = false;
            _showCompletionDialog();
            _buttonText = "INICIAR";
            _buttonColor = Colors.green;
          }
        });
        
        // Retornamos false si el timer ha terminado
        if (_remainingSeconds <= 0) {
          return false;
        }
      }
      
      return _isRunning && !_isPaused && _remainingSeconds > 0;
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
      _buttonText = "CONTINUAR";
      _buttonColor = Colors.blue;
    });
  }

  void _resumeTimer() {
    setState(() {
      _isPaused = false;
      _buttonText = "PAUSAR";
      _buttonColor = Colors.orange;
    });
    _startTimer();
  }

  void _resetTimer() {
    setState(() {
      _isRunning = false;
      _isPaused = false;
      _remainingSeconds = _totalSeconds;
      _buttonText = "INICIAR";
      _buttonColor = Colors.green;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¡Tiempo Completado!"),
          content: const Text("Has completado tu período de tiempo establecido."),
          actions: [
            TextButton(
              child: const Text("CERRAR"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("REINICIAR"),
              onPressed: () {
                _resetTimer();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final double progress = _isRunning 
        ? (_remainingSeconds / _totalSeconds) 
        : 1.0;
    
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Tarjeta de configuración
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Text(
                    "Configuración del Temporizador",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _minutesController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Minutos",
                            labelStyle: const TextStyle(color: Colors.white70),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.white),
                            ),
                          ),
                          enabled: !_isRunning,
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _isRunning ? null : _setTime,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text("APLICAR"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Timer Display
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Progress Circle
                SizedBox(
                  width: 280,
                  height: 280,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 15,
                    backgroundColor: Colors.grey.withOpacity(0.3),
                    color: _isRunning
                        ? (_isPaused ? Colors.blue : Colors.green)
                        : (_remainingSeconds <= 0 ? Colors.red : Colors.green),
                  ),
                ),
                // Time Text
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _formatTime(_remainingSeconds),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _isRunning
                          ? (_isPaused ? "PAUSADO" : "EN PROGRESO")
                          : (_remainingSeconds <= 0 ? "COMPLETADO" : "LISTO"),
                      style: TextStyle(
                        color: _isRunning
                            ? (_isPaused ? Colors.blue : Colors.green)
                            : (_remainingSeconds <= 0 ? Colors.red : Colors.white70),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Control Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  if (!_isRunning) {
                    _startTimer();
                  } else if (_isPaused) {
                    _resumeTimer();
                  } else {
                    _pauseTimer();
                  }
                },
                icon: Icon(
                  !_isRunning
                      ? Icons.play_arrow
                      : (_isPaused ? Icons.play_arrow : Icons.pause),
                ),
                label: Text(_buttonText),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _buttonColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: _isRunning ? _resetTimer : null,
                icon: const Icon(Icons.refresh),
                label: const Text("RESET"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
              ),
            ],
          ),
          
          // Tips Card
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: Colors.amber,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "TIPS DE DESCANSO",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Para ejercicios de fuerza, descansa de 60 a 90 segundos entre series para un músculo grande, y de 30 a 60 segundos para músculos pequeños.",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
