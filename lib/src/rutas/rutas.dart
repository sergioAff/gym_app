import 'package:flutter/material.dart';
import 'package:gym/src/paginas/app.dart';
import 'package:gym/src/paginas/imc_page.dart';
import 'package:gym/src/temporizador/temporizador.dart';

rutas(BuildContext context) {
  final r = <String, WidgetBuilder>{
    "HomePage": (context) => const PrincipalPage(),
    'imc': (context) => ImcPage(),
    'temp': (context) => Tempor(),
  };
  return r;
}
