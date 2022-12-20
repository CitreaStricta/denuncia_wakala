import 'dart:async';

import 'package:denuncia_wakala/main.dart';
import 'package:denuncia_wakala/models/post.dart';
import 'package:denuncia_wakala/pages/image_Viewer.dart';
import 'package:denuncia_wakala/utils/utiles.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../global.dart';
import 'dart:convert';

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
  TextEditingController commentController = TextEditingController();
  bool comentarioPublicado = false;

  _DetallesState(this.post);

  @override
  void initState() {
    super.initState();
  }

  void postearComentario(int wid, String comentario, int uid) async {
    await http.post(
      Uri.parse('${Global.baseApiUrl}/api/comentariosApi/Postcomentario'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id_wuakala': wid.toString(),
        'descripcion': comentario,
        'id_autor': uid.toString(),
      }),
    );
    dynamic refreshPost;
    await http
        .get(Uri.parse('${Global.baseApiUrl}/api/wuakalasApi/Getwuakala/$wid'))
        .then((http.Response response) {
      refreshPost = jsonDecode(response.body);
      post.comentarios = refreshPost['comentarios'];
    });
  }

  Widget checkComentarioPublicado() {
    if (comentarioPublicado) {
      return Column(
        children: const [
          SizedBox(height: 20),
          Text(
            "¡Se ha publicado tu comentario!",
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 10),
        ],
      );
    } else {
      return Container();
    }
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

  Widget comentario(index, ultimo) {
    return Padding(
      padding: ultimo
          ? const EdgeInsets.all(6.0)
          : const EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          color: const Color.fromARGB(255, 250, 250, 250),
          child: ListTile(
            title: Text(post.comentarios[index]['descripcion']),
            subtitle: Text(post.comentarios[index]['autor']),
          ),
        ),
      ),
    );
  }

  Widget getListView(int length) {
    if (length > 0) {
      return ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: post.comentarios.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: 0,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return comentario(index, index == post.comentarios.length - 1);
        },
      );
    } else {
      return const Center(
        child: Text(
          "Se el primero en comentar",
          style: TextStyle(
              fontSize: 16, color: Color.fromARGB(255, 142, 137, 140)),
        ),
      );
    }
  }

  void sigueAhi(context) async {
    await http.put(
      Uri.parse('${Global.baseApiUrl}/api/wuakalasApi/PutSigueAhi/${post.id}'),
    );
  }

  void yaNoEsta(context) async {
    await http.put(
      Uri.parse('${Global.baseApiUrl}/api/wuakalasApi/PutYanoEsta/${post.id}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // este container si es innecesario (prueba)
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: BackButton(),
                  ),
                  // parsear el SECTOR aqui con los datos de la api
                  Flexible(
                    fit: FlexFit.tight,
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        post.sector,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 54),
                ],
              ),

              const SizedBox(height: 10),

              // parsear LA DESCRIPCION aqui con los datos de la api
              Text(
                post.descripcion,
                style: const TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 10),

              // AQUI LAS DOS IMAGENES QUE SE DEBEN PODER VER Y PODER CLIQUEAR\
              imagesShower(context),

              const SizedBox(height: 10),

              // parsear AUTOR aqui con los datos de la api
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Publicado por ',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    post.autor,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  const Text(
                    '.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
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
                      post.sigueAhi = (int.parse(post.sigueAhi) + 1).toString();
                      setState(() {});
                      sigueAhi(context);
                    },

                    /* debe incluir el numero de botos que tiene*/
                    child: Row(
                      children: [
                        const Text("Sigue ahi"),
                        const SizedBox(width: 10),
                        Text(
                          post.sigueAhi,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize:
                          Size(MediaQuery.of(context).size.width * 0.3, 60),
                    ),
                    onPressed: () {
                      post.yaNoEsta = (int.parse(post.yaNoEsta) + 1).toString();
                      setState(() {});
                      yaNoEsta(context);
                    },

                    /* debe incluir el numero de botos que tiene*/
                    child: Row(
                      children: [
                        const Text("Ya no está"),
                        const SizedBox(width: 10),
                        Text(
                          post.yaNoEsta,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Spacer(),
                ],
              ),

              const SizedBox(height: 10),
              const Text(
                "Comentarios",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              checkComentarioPublicado(),

              const SizedBox(height: 10),
              // aqui poner los comentarios

              Flexible(
                fit: FlexFit.tight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    color: const Color.fromARGB(26, 125, 119, 121),
                    child: getListView(post.comentarios.length),
                  ),
                ),
              ),

              // Text Field de comentario y boton para publicar
              const SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width - 10,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          hintText: "Comentar",
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(100, 60),
                      ),
                      onPressed: () {
                        if (commentController.text.isNotEmpty) {
                          comentarioPublicado = true;
                          setState(() {});
                          postearComentario(
                            post.id!,
                            commentController.text,
                            Global.localId,
                          );
                          commentController.text = "";
                          Timer(const Duration(seconds: 2), () {
                            setState(() {
                              comentarioPublicado = false;
                              setState(() {});
                            });
                          });
                        }
                      },
                      child: const Text("Publicar"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
