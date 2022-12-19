import 'package:denuncia_wakala/models/post.dart';
import 'package:denuncia_wakala/pages/image_Viewer.dart';
import 'package:denuncia_wakala/utils/utiles.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global.dart';

class Detalles extends StatefulWidget {
  // static const routeName = '/detailTodoScreen';
  // File? imagen;

  final Post post;
  const Detalles({super.key, required this.post});

  @override
  State<Detalles> createState() => _DetallesState(post);
}

class _DetallesState extends State<Detalles> {
  Post post;

  _DetallesState(this.post);

  Future<String> getImage(String imagenB64) async {
    return (await http.post(Uri.parse(
            "${Global.baseApiUrl}/api/wuakalasApi/toImagen?base64=$imagenB64")))
        .body;
  }

  Future<List<String>> queryImages(context) async {
    return [
      await getImage(post.urlFoto1),
      await getImage(post.urlFoto2),
    ];
  }

  Widget imageShower(context, String fotoURL) {
    return GestureDetector(
      onTap: () {
        showImageViewer(context,
            Image.network('${Global.baseApiUrl}/images/$fotoURL').image,
            swipeDismissible: false);
      },
      child: Container(
        width: 150,
        height: 400,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Image.network('${Global.baseApiUrl}/images/$fotoURL'),
      ),
    );

    // return GestureDetector(
    //     onTap: (() => {
    //           Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => const ImageViewer(),
    //             ),
    //           ),
    //         }),
    //     child: Container(
    //       width: 150,
    //       height: 400,
    //       padding: const EdgeInsets.symmetric(vertical: 16.0),
    //       child: Image.network('${Global.baseApiUrl}/images/$fotoURL'),
    //     ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // este container si es innecesario (prueba)
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // parsear el sectro aqui con los datos de la api
                Text(post.sector),
                // parsear LA DESCRIPCION aqui con los datos de la api
                Text(post.descripcion),
                // AQUI LAS DOS IMAGENES QUE SE DEBEN PODER VER Y PODER CLIQUEAR\
                Row(children: [
                  const Spacer(),
                  imageShower(context, post.urlFoto1),
                  const Spacer(),
                  imageShower(context, post.urlFoto2),
                  const Spacer(),
                ]),
                Text(post.autor),
                Row(
                  children: [
                    // boton para "sigue ahi"
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(150, 60),
                      ),
                      onPressed: () {
                        // que aumente el conteo de "Sigue ahi (x)"
                      },

                      /* debe incluir el numero de botos que tiene*/
                      child: const Text("Sigue ahi"),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(150, 60),
                      ),
                      onPressed: () {
                        // que aumente el conteo de "Ya no esta (x)"
                      },

                      /* debe incluir el numero de botos que tiene*/
                      child: const Text("Sigue ahi (x)"),
                    ),
                    const Spacer(),
                  ],
                ),
                Row(
                  children: [
                    const Text("Comentarios"),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(10, 60),
                      ),
                      onPressed: () {
                        // que nos lleve a la creacion de comentario
                      },

                      /* debe incluir el numero de botos que tiene*/
                      child: const Text("Comentar"),
                    ),
                  ],
                ),
                //Row(
                //   children: const [
                //  aqui va a ser mas webeado.
                // Hay que hacer un "for" que nos
                // devuelve todos los comentarios
                //  que se han hecho en este wuakala
                //   ],
                // ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    minimumSize: const Size(10, 60),
                  ),
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
