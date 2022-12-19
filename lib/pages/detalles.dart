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
    if (fotoURL.isEmpty) return Container();
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
  }

  Widget imagesShower(context) {
    List<Widget> data = [const Spacer()];
    if (post.urlFoto1.isNotEmpty) {
      data.add(
        GestureDetector(
          onTap: () {
            showImageViewer(
                context,
                Image.network('${Global.baseApiUrl}/images/${post.urlFoto1}')
                    .image,
                swipeDismissible: false);
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.4,
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                '${Global.baseApiUrl}/images/${post.urlFoto1}',
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ),
      );
      data.add(const Spacer());
    }
    if (post.urlFoto2.isNotEmpty) {
      data.add(
        GestureDetector(
          onTap: () {
            showImageViewer(
                context,
                Image.network('${Global.baseApiUrl}/images/${post.urlFoto2}')
                    .image,
                swipeDismissible: false);
          },
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.4,
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                '${Global.baseApiUrl}/images/${post.urlFoto2}',
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
        ),
      );
      data.add(const Spacer());
    }
    return Row(
      children: data,
    );
  }

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

  Widget comentario(index) {
    return ListTile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: SizedBox(
        width: double.infinity,
        height: 80,
        child: Column(children: const [
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              hintText: "Comentar",
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // este container si es innecesario (prueba)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // parsear el SECTOR aqui con los datos de la api
              Text(
                post.sector,
                textScaleFactor: 2.0,
              ),
              const SizedBox(height: 10),

              // parsear LA DESCRIPCION aqui con los datos de la api
              Text(
                post.descripcion,
                textScaleFactor: 1.2,
              ),
              const SizedBox(height: 10),

              // AQUI LAS DOS IMAGENES QUE SE DEBEN PODER VER Y PODER CLIQUEAR\
              imagesShower(context),
              const SizedBox(height: 10),

              // parsear AUTOR aqui con los datos de la api
              Text(
                post.autor,
                textScaleFactor: 1.2,
              ),
              const SizedBox(height: 10),

              // Botones para decir si sigue ahi o si no sigue ahí
              Row(
                children: [
                  // boton para "sigue ahi"
                  const Spacer(),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.3, 60),
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
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.3, 60),
                    ),
                    onPressed: () {
                      // que aumente el conteo de "Ya no esta (x)"
                    },

                    /* debe incluir el numero de botos que tiene*/
                    child: const Text("Sigue ahi (x)"),
                  ),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),
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
              // aqui poner los comentarios
              ListView.builder(
                itemCount: post.comentarios.length,
                itemBuilder: (BuildContext context, int index) {
                  return comentario(index);
                },
              ),

              // aqui poner los comentarios

              const SizedBox(height: 10),
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
    );
  }
}
