import 'package:flutter/material.dart';

class ImcPage extends StatelessWidget {
  const ImcPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Imc(),
    );
  }
}

class Imc extends StatefulWidget {
  const Imc({Key? key});

  @override
  _ImcState createState() => _ImcState();
}

class _ImcState extends State<Imc> {
  double altura = 0;
  double peso = 0;
  double imc = 0;
  String clasificacion = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 100, 100, 20),
        title: const Center(child: Text('IMC')),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                const Text(
                  "Kilogramos:",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  width: 135,
                ),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        peso = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                const Text(
                  "Metros:",
                  style: TextStyle(fontSize: 30),
                ),
                const SizedBox(
                  width: 190,
                ),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (String value) {
                      setState(() {
                        altura = double.tryParse(value) ?? 0;
                      });
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      imc.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 60, color: Colors.red),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        const Text(
                          'IMC',
                          style: TextStyle(fontSize: 32),
                        ),
                        Text(clasificacion),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(
                  color: Colors.black87,
                  height: 10,
                  thickness: 5,
                  indent: 10,
                  endIndent: 10,
                ),
                const SizedBox(
                  height: 12,
                ),
                const Text('Informacion'),
                const SizedBox(
                  height: 12,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Bajo de Peso', style: TextStyle(color: Colors.blue)),
                    SizedBox(
                      width: 50,
                    ),
                    Text(
                      'Normal',
                      style: TextStyle(color: Colors.green),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    Text('Sobrepeso', style: TextStyle(color: Colors.red)),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
                Container(
                  height: 10,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green, Colors.red],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('16.0'),
                    SizedBox(
                      width: 50,
                    ),
                    Text('18.5'),
                    SizedBox(
                      width: 100,
                    ),
                    Text('25.0'),
                    SizedBox(
                      width: 50,
                    ),
                    Text('40.0'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(color: Colors.orange),
                  ),
                  onPressed: () {
                    setState(() {
                      imc = peso / (altura * altura);
                      if (imc < 18.5) {
                        clasificacion = 'Bajo de Peso';
                      } else if (imc < 25) {
                        clasificacion = 'Normal';
                      } else if (imc < 30) {
                        clasificacion = 'Sobrepeso';
                      } else {
                        clasificacion = 'Obeso';
                      }
                    });
                  },
                  child: const Text('GO'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
