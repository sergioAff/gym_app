import 'package:flutter/material.dart';
import 'package:gym/src/data/data.dart';
import 'package:gym/src/ejercicios/ejercicios.dart';
import 'package:provider/provider.dart';
import '../modo oscuro/oscuro.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({Key? key}) : super(key: key);

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
  late PlanEjercicios ejerciciosBrazos;
  late PlanEjercicios ejerciciosAbdomen;
  late PlanEjercicios ejerciciosPiernas;

  @override
  void initState() {
    super.initState();
    ejerciciosBrazos = PlanEjercicios(
      brazo(),
      imagenes().sublist(0, 8),
    );
    ejerciciosAbdomen = PlanEjercicios(
      abdomen(),
      imagenes().sublist(7, 15),
    );
    ejerciciosPiernas = PlanEjercicios(
      piernas(),
      imagenes().sublist(14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mis Favoritos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode
                  ? Icons.wb_sunny_outlined
                  : Icons.nightlight_round,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, provider, child) {
          int totalFavoritos = provider.favorites.length;
          
          return Column(
            children: [
              // Banner con contador de favoritos
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ejercicios favoritos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          totalFavoritos == 0
                              ? 'No tienes ejercicios favoritos'
                              : totalFavoritos == 1
                                  ? 'Tienes 1 ejercicio favorito'
                                  : 'Tienes $totalFavoritos ejercicios favoritos',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          'Guarda más',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Lista de favoritos
              Expanded(
                child: totalFavoritos == 0
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 72,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No tienes ejercicios favoritos',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Marca tus ejercicios con el corazón\npara guardarlos aquí',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.fitness_center),
                              label: const Text('Explorar ejercicios'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ejercicios de brazos favoritos
                            _buildCategorySection(context, 'Brazos', ejerciciosBrazos),
                            
                            // Ejercicios de abdomen favoritos
                            _buildCategorySection(context, 'Abdomen', ejerciciosAbdomen),
                            
                            // Ejercicios de piernas favoritos
                            _buildCategorySection(context, 'Piernas', ejerciciosPiernas),
                            
                            const SizedBox(height: 80), // Para evitar que el floating action button tape
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.home),
        tooltip: 'Volver al inicio',
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context, String title, PlanEjercicios ejercicios) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    // Filtrar los ejercicios por título para ver si hay alguno en favoritos
    Map ejerciciosMap = ejercicios.listaEjercicios();
    bool hasMatchingFavorites = ejerciciosMap.keys.any(
      (titulo) => themeProvider.isFavorite(titulo),
    );
    
    // Si no hay favoritos en esta categoría, no mostrar la sección
    if (!hasMatchingFavorites) {
      return const SizedBox.shrink();
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(
                title == 'Brazos'
                    ? Icons.fitness_center
                    : title == 'Abdomen'
                        ? Icons.sports_gymnastics
                        : Icons.directions_run,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
        ...ejercicios.listTitles(context, onlyFavorites: true),
      ],
    );
  }
} 