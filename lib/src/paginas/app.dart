import 'package:flutter/material.dart';
import 'package:gym/src/data/data.dart';
import 'package:gym/src/paginas/excercise_list_page.dart';
import 'package:gym/src/paginas/imc_page.dart';
import 'package:provider/provider.dart';
import '../modo oscuro/oscuro.dart';
import 'package:gym/src/paginas/Info.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Gym',
      home: PrincipalPage(),
    );
  }
}

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({Key? key}) : super(key: key);

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final List<Widget> _kTabPages = <Widget>[
    ScrollablePage(
      datos: brazo(),
      lista: imagenes().sublist(0, 8),
      imagen: "assets/brazo.jpg",
    ),
    ScrollablePage(
      datos: abdomen(),
      lista: imagenes().sublist(7, 15),
      imagen: "assets/abdomen.jpg",
    ),
    ScrollablePage(
      datos: piernas(),
      lista: imagenes().sublist(14),
      imagen: "assets/piernas.jpg",
    )
  ];

  final _kTabs = <Tab>[
    Tab(
      icon: Image.asset(
        "assets/arm_muscle_male_body_icon_143229.ico",
        width: 40,
        height: 40,
        scale: 2,
      ),
      text: 'Brazos',
    ),
    Tab(
      icon: Image.asset(
        "assets/chest_male_body_icon_143226.ico",
        width: 40,
        height: 40,
        scale: 2,
      ),
      text: 'Abdomen',
    ),
    Tab(
      icon: Image.asset(
        "assets/leg_muscle_body_icon_143225.ico",
        width: 40,
        height: 40,
        scale: 2,
      ),
      text: 'Piernas',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gym'),
          backgroundColor: const Color.fromRGBO(0, 100, 100, 20),
          bottom: TabBar(
            tabs: _kTabs,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'temp');
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.access_time, color: Colors.white),
        ),
        drawer: _crearMenu(context),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}

Drawer _crearMenu(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/portada2.jpg"), fit: BoxFit.cover),
            ),
            child: Container()),
        Material(
          child: ListTile(
            title: const Text('Modo noche'),
            leading: const Icon(Icons.nightlight_round),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
          ),
        ),
        Material(
          child: ListTile(
              leading: const Icon(Icons.line_weight),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
              ),
              title: const Text('IMC'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ImcPage()),
                );
              }),
        ),
        Material(
          child: ListTile(
            title: const Text('Información'),
            leading: const Icon(Icons.info),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Info()),
              );
            },
          ),
        ),
      ],
    ),
  );
}
