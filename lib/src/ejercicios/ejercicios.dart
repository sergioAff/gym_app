import 'package:flutter/material.dart';

class Ejercicio {
  late final String _titulo;
  late final String _gifnombre;

  late final String _informacion;
  Ejercicio(this._titulo, this._informacion, this._gifnombre);

  String get titulo {
    return _titulo;
  }

  String get gifnombre {
    return _gifnombre;
  }

  String get informacion {
    return _informacion;
  }
}

class PlanEjercicios {
  late Map info;
  late List<String> imagen;
  PlanEjercicios(this.info, this.imagen);
  Map listaEjercicios() {
    Map r = {};
    int i = 0;
    for (String elem in info.keys) {
      Ejercicio ejr = Ejercicio(elem, info[elem], imagen[i]);
      r[elem] = ejr;
      i++;
    }
    return r;
  }

  List<Widget> listTitles(BuildContext context) {
    final Map r = listaEjercicios();
    List<Widget> lista = [];
    for (String i in r.keys) {
      Ejercicio variable = r[i];
      Widget elemento = GestureDetector(
          onTap: () => MostrarAlerta(context, variable),
          child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              height: 80,
              width: 20,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 76, 76, 1),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 100, 100, 20),
                    blurRadius: 1,
                    spreadRadius: 3,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                child: ListTile(
                  trailing: const Icon(Icons.keyboard_arrow_right),
                  iconColor: Colors.white,
                  title: Text(i),
                  textColor: Colors.white,
                  titleTextStyle: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                  leading: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(variable._gifnombre),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(1, 1))
                          ])),
                ),
              )));
      lista.add(elemento);
      lista.add(const Divider());
    }
    return lista;
  }

  // ignore: non_constant_identifier_names
  void MostrarAlerta(BuildContext context, Ejercicio ejercicio) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            title: Text(
              ejercicio._titulo,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    width: 400,
                    height: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ejercicio._gifnombre),
                        fit: BoxFit.cover,
                      ),
                    )),
                const SizedBox(
                  height: 15,
                ),
                const Divider(color: Colors.black),
                Text(
                  ejercicio._informacion,
                ),
                const Divider(color: Colors.black)
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              )
            ],
          );
        });
  }
}
