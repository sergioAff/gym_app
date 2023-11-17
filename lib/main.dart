import 'package:flutter/material.dart';
import 'package:gym/src/rutas/rutas.dart';
import 'package:provider/provider.dart';
import 'package:gym/src/modo oscuro/oscuro.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Gym App",
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: "HomePage",
      routes: rutas(context),
    );
  }
}
