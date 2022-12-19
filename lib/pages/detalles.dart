import 'package:denuncia_wakala/models/post.dart';
import 'package:denuncia_wakala/pages/image_Viewer.dart';
import 'package:flutter/material.dart';

class Detalles extends StatefulWidget {
  // static const routeName = '/detailTodoScreen';
  // File? imagen;

  final Post post;
  const Detalles({super.key, required this.post});

  @override
  State<Detalles> createState() => _DetallesState(post);
}

class _DetallesState extends State<Detalles> {
  // File? imagenAMostrar;

  Post post;
  _DetallesState(this.post);

  // @override
  // void initState() {
  //   super.initState();
  //   if (imagenAMostrar != null) {}
  // }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  Widget imageShower(context) {
    return GestureDetector(
      onTap: (() => {
            Navigator.push(
              context,
              // de alguna forma entregarle la imagen a la vista siguiente
              MaterialPageRoute(
                builder: (context) => const ImageViewer(),
              ),
            ),
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // parsear el sectro aqui con los datos de la api
                Text(post.sector),
                // parsear LA DESCRIPCION aqui con los datos de la api
                Text(post.descripcion),
                // AQUI LAS DOS IMAGENES QUE SE DEBEN PODER VER Y PODER CLIQUEAR\
                //Row(children: const [
                //  /*imageShower(context), imageShower(context)*/
                //]),
                Text(post.autor),
                Row(
                  children: [
                    // boton para "sigue ahi"
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: const Size(10, 60)),
                      onPressed: () {
                        // que aumente el conteo de "Sigue ahi (x)"
                      },

                      /* debe incluir el numero de botos que tiene*/
                      child: const Text("Sigue ahi"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: const Size(10, 60)),
                      onPressed: () {
                        // que aumente el conteo de "Ya no esta (x)"
                      },

                      /* debe incluir el numero de botos que tiene*/
                      child: const Text("Sigue ahi (x)"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Comentarios"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          minimumSize: const Size(10, 60)),
                      onPressed: () {
                        // que nos lleve a la creacion de comentario
                      },

                      /* debe incluir el numero de botos que tiene*/
                      child: const Text("Comentar"),
                    ),
                  ],
                ),
                //Row(
                //  children: const [
                //    // aqui va a ser mas webeado.
                //    //Hay que hacer un "for" que nos
                //    //devuelve todos los comentarios
                //    // que se han hecho en este wuakala
                //  ],
                //),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: const Size(10, 60)),
                  onPressed: () {
                    Navigator.pop(context);
                  },

                  /* debe incluir el numero de botos que tiene*/
                  child: const Text("Volver al Listado"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
