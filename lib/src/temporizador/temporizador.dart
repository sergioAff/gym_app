import 'package:flutter/material.dart';
import 'dart:async';

class TemporizadorWidget extends StatefulWidget {
  final int tiempo;

  const TemporizadorWidget({Key? key, required this.tiempo}) : super(key: key);

  @override
  _TemporizadorWidgetState createState() => _TemporizadorWidgetState();
}

class _TemporizadorWidgetState extends State<TemporizadorWidget> {
  int segundos = 0;
  late Timer timer;
  int? tiempoIngresado;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void iniciarTemporizador() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        segundos++;
      });

      if (segundos >= tiempoIngresado!) {
        timer.cancel();
        _mostrarDialogo();
      }
    });
  }

  String _obtenerTiempoFormateado() {
    int minutos = segundos ~/ 60;
    int segundosRestantes = segundos % 60;
    String minutosStr = (minutos % 60).toString().padLeft(2, '0');
    String segundosStr = segundosRestantes.toString().padLeft(2, '0');
    return '$minutosStr:$segundosStr';
  }

  void _mostrarDialogo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tiempo Concluido'),
          content: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 30,
      right: 16,
      child: Container(
        height: 340,
        width: 340,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          border: Border.all(width: 4, color: Colors.black),
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(180),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _obtenerTiempoFormateado(),
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 14,
            ),
            Container(
              width: 74,
              height: 60,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 20),
                decoration: InputDecoration(
                  labelText: "Time:",
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.black.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (valor) {
                  setState(() {
                    tiempoIngresado = int.tryParse(valor);
                    segundos = 0;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                if (tiempoIngresado != null) {
                  iniciarTemporizador();
                }
              },
              child: const Text('Iniciar'),
            ),
          ],
        ),
      ),
    );
  }
}

class Tempor extends StatelessWidget {
  const Tempor({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Temporizador de Gym',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const GymScreen(),
    );
  }
}

class GymScreen extends StatelessWidget {
  final int tiempoEjercicio = 60;

  const GymScreen({Key? key}); // Tiempo en segundos para el ejercicio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 100, 100, 20),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TemporizadorWidget(tiempo: tiempoEjercicio),
          ],
        ),
      ),
    );
  }
}
