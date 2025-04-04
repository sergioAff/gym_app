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
      theme: themeProvider.isDarkMode 
        ? ThemeData.dark().copyWith(
            primaryColor: const Color(0xFF1E3E63),
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF1E3E63),
              secondary: Color(0xFF5D9CEC),
              surface: Color(0xFF172A43),
              background: Color(0xFF0A1929),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E3E63),
              elevation: 0,
            ),
            cardTheme: CardTheme(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF5D9CEC),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
            ),
          ) 
        : ThemeData.light().copyWith(
            primaryColor: const Color(0xFF00897B),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF00897B),
              secondary: Color(0xFF26A69A),
              surface: Colors.white,
              background: Color(0xFFF5F5F5),
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF00897B),
              elevation: 0,
            ),
            cardTheme: CardTheme(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF00897B),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
              ),
            ),
          ),
      initialRoute: "HomePage",
      routes: rutas(context),
    );
  }
}
