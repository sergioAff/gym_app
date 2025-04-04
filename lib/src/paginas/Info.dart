import 'package:flutter/material.dart';

class Info extends StatefulWidget {
  const Info({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          const ListTile(
            title: Text(
              'Info...',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Image.asset('assets/portada1.jpg'),
          ),
          const Divider(),
          const ListTile(
            title: Text(
              'Desarrollada por: Universidad de Cienfuegos',
              style: TextStyle(fontSize: 19),
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
            ),
          ),
          const ListTile(
            title: Text(
              'Autores:',
              style: TextStyle(fontSize: 21),
            ),
          ),
          const ListTile(
            title: Text(
              '  Alex Manuel Montero magariño',
              style: TextStyle(fontSize: 17),
            ),
          ),
          const ListTile(
            title: Text(
              '  Sergio Adrian Fernández Figueredo',
              style: TextStyle(fontSize: 17),
            ),
          ),
          const ListTile(
            title: Text(
              '  Marcos Antonio Bermúdez Suárez',
              style: TextStyle(fontSize: 17),
            ),
          ),
          const Divider(),
          const ListTile(
            title: Text(
              'Versión 1.0.0',
              style: TextStyle(fontSize: 19),
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
            ),
          ),
        ],
      ),
    );
  }
}
