import 'package:flutter/material.dart';
import '../ejercicios/ejercicios.dart';

class ScrollablePage extends StatefulWidget {
  final Map<String, String> datos;
  final List<String> lista;
  final String imagen;
  const ScrollablePage(
      {super.key,
      required this.datos,
      required this.lista,
      required this.imagen});

  @override
  State<ScrollablePage> createState() => _ScrollablePageState();
}

class _ScrollablePageState extends State<ScrollablePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox.fromSize(
          child: SizedBox(
            height: 220,
            width: 800,
            child: Image(image: AssetImage(widget.imagen), fit: BoxFit.fill),
          ),
        ),
        _buildDraggableScrollableSheet(),
      ],
    );
  }

  DraggableScrollableSheet _buildDraggableScrollableSheet() {
    PlanEjercicios listaEjercicios = PlanEjercicios(widget.datos, widget.lista);
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.7,
      maxChildSize: 0.8,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 100, 100, 1),
            // border: Border.all(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
          ),
          child: Scrollbar(
              child: ListView(
            controller: scrollController,
            children: listaEjercicios.listTitles(context),
          )),
        );
      },
    );
  }
}
