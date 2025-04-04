import 'package:flutter/material.dart';
import 'package:gym/src/data/data.dart';
import 'package:gym/src/paginas/excercise_list_page.dart';
import 'package:gym/src/paginas/imc_page.dart';
import 'package:provider/provider.dart';
import '../modo oscuro/oscuro.dart';
import 'package:gym/src/paginas/Info.dart';
import 'package:gym/src/paginas/favoritos_page.dart';

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

class _PrincipalPageState extends State<PrincipalPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final List<Widget> _kTabPages = <Widget>[
    ScrollablePage(
      datos: brazo(),
      lista: imagenes().sublist(0, 8),
      imagen: "assets/brazo.jpg",
      title: "Ejercicios para Brazos",
      description: "Fortalece y tonifica tus brazos con esta colección de ejercicios",
    ),
    ScrollablePage(
      datos: abdomen(),
      lista: imagenes().sublist(7, 15),
      imagen: "assets/abdomen.jpg",
      title: "Ejercicios para Abdomen",
      description: "Trabaja tu core y consigue un abdomen definido",
    ),
    ScrollablePage(
      datos: piernas(),
      lista: imagenes().sublist(14),
      imagen: "assets/piernas.jpg",
      title: "Ejercicios para Piernas",
      description: "Fortalece tus piernas y glúteos con estos ejercicios",
    )
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: _isSearching 
            ? TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Buscar ejercicios...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                autofocus: true,
              )
            : const Text(
                'GYM APP', 
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
          elevation: 0,
          actions: [
            // Botón de búsqueda
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchQuery = '';
                  }
                });
              },
            ),
            // Botón de favoritos
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritosPage(),
                  ),
                );
              },
            ),
            // Botón de tema
            IconButton(
              icon: Icon(isDark ? Icons.wb_sunny_outlined : Icons.nightlight_round),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorWeight: 3,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: const Icon(Icons.fitness_center),
                text: 'Brazos',
                iconMargin: const EdgeInsets.only(bottom: 4),
              ),
              Tab(
                icon: const Icon(Icons.sports_gymnastics),
                text: 'Abdomen',
                iconMargin: const EdgeInsets.only(bottom: 4),
              ),
              Tab(
                icon: const Icon(Icons.directions_run),
                text: 'Piernas',
                iconMargin: const EdgeInsets.only(bottom: 4),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, 'temp');
          },
          icon: const Icon(Icons.timer),
          label: const Text('Timer'),
          elevation: 4,
        ),
        drawer: _crearMenu(context),
        body: TabBarView(
          controller: _tabController,
          children: _kTabPages,
        ),
      ),
    );
  }
}

Drawer _crearMenu(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final theme = Theme.of(context);

  return Drawer(
    elevation: 8,
    child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage("assets/portada2.jpg"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black26,
                BlendMode.darken,
              ),
            ),
            borderRadius: BorderRadius.circular(0),
          ),
          accountName: const Text(
            "Mi Entrenamiento",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 3,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          accountEmail: const Text(
            "Personal Fitness Guide",
            style: TextStyle(
              fontSize: 16,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 3,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: AssetImage("assets/flutter_logo.png"),
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.home_outlined,
                  color: theme.colorScheme.primary,
                ),
                title: const Text(
                  'Inicio',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: theme.colorScheme.primary,
                ),
                title: const Text(
                  'Favoritos',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Tus ejercicios guardados'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FavoritosPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.nightlight_round,
                  color: theme.colorScheme.primary,
                ),
                title: const Text('Modo oscuro'),
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  activeColor: theme.colorScheme.secondary,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ),
              const Divider(),
              ListTile(
                  leading: Icon(
                    Icons.monitor_weight_outlined,
                    color: theme.colorScheme.primary,
                  ),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: theme.colorScheme.primary,
                  ),
                  title: const Text(
                    'Calculadora IMC',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: const Text('Calcula tu índice de masa corporal'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ImcPage()),
                    );
                  }),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.info_outline,
                  color: theme.colorScheme.primary,
                ),
                title: const Text(
                  'Información',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text('Acerca de la aplicación'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Info()),
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: const Text(
            'v1.1.0',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    ),
  );
}
