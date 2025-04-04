import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modo oscuro/oscuro.dart';

class Ejercicio {
  late final String _titulo;
  late final String _gifnombre;
  late final String _informacion;
  
  Ejercicio(this._titulo, this._informacion, this._gifnombre);

  String get titulo => _titulo;
  String get gifnombre => _gifnombre;
  String get informacion => _informacion;
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

  List<Widget> listTitles(BuildContext context, {bool onlyFavorites = false}) {
    final Map r = listaEjercicios();
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    List<Widget> lista = [];
    
    int index = 0;
    for (String i in r.keys) {
      // Si estamos en modo favoritos, saltamos los que no son favoritos
      if (onlyFavorites && !themeProvider.isFavorite(i)) {
        continue;
      }
      
      Ejercicio variable = r[i];
      Widget elemento = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _mostrarDetalleEjercicio(context, variable),
            splashColor: theme.colorScheme.primary.withOpacity(0.3),
            child: Row(
              children: [
                // Exercise image
                Hero(
                  tag: 'exercise-${variable.titulo}',
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(variable.gifnombre),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Exercise details
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                variable.titulo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            Consumer<ThemeProvider>(
                              builder: (context, provider, child) {
                                return IconButton(
                                  icon: Icon(
                                    provider.isFavorite(variable.titulo)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: provider.isFavorite(variable.titulo)
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    provider.toggleFavorite(variable.titulo);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getExcerpt(variable.informacion),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.fitness_center,
                              size: 16,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Ver detalles',
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Arrow icon
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      
      lista.add(elemento);
      index++;
    }
    
    if (lista.isEmpty && onlyFavorites) {
      lista.add(
        Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
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
                  'Marca tus ejercicios con el corazón para guardarlos aquí',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    
    return lista;
  }

  // Get a short excerpt of the exercise description
  String _getExcerpt(String text) {
    if (text.length > 100) {
      return "${text.substring(0, 100)}...";
    }
    return text;
  }

  // Show exercise details in a modal bottom sheet for better UX
  void _mostrarDetalleEjercicio(BuildContext context, Ejercicio ejercicio) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Handle indicator
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              
              // Exercise title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.fitness_center,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        ejercicio.titulo,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    Consumer<ThemeProvider>(
                      builder: (context, provider, child) {
                        return IconButton(
                          icon: Icon(
                            provider.isFavorite(ejercicio.titulo)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: provider.isFavorite(ejercicio.titulo)
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: () {
                            provider.toggleFavorite(ejercicio.titulo);
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              
              Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.2)),
              
              // Exercise content - scrollable
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Exercise image
                      Hero(
                        tag: 'exercise-${ejercicio.titulo}',
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(ejercicio.gifnombre),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      
                      // Exercise description
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Instrucciones',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              ejercicio.informacion,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Action button
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'ENTENDIDO',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
