import 'package:denuncia_wakala/pages/crear_publicacion.dart';
import 'package:flutter/material.dart';

class ListaPublicaciones extends StatefulWidget {
  const ListaPublicaciones({super.key});

  @override
  State<ListaPublicaciones> createState() => _ListaPublicacionesState();
}

// clase donde se pueden ver todas las publicaciones
class _ListaPublicacionesState extends State<ListaPublicaciones> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hola!"),
      ),
      // boton para hacer una publicacion
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CrearPublicacion()));
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
