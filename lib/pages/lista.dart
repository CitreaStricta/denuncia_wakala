import 'dart:convert';

import 'package:denuncia_wakala/models/post.dart';
import 'package:denuncia_wakala/pages/crear_publicacion.dart';
import 'package:denuncia_wakala/pages/detalles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global.dart';

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  Future<List<dynamic>> getPosts() async {
    return jsonDecode((await http
            .get(Uri.parse('${Global.baseApiUrl}/api/wuakalasApi/Getwuakalas')))
        .body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: NavBar(),
      appBar: AppBar(
        title: Text('¡Bienvenido, ${Global.localUsername}!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearPublicacion(),
            ),
          );
        },
        tooltip: "Denunciar wuakala",
        child: const Icon(Icons.add_rounded),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getPosts(),
        builder: (context, snapshot) {
          //snapshot.data es la List<dynamic>
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data![index]['sector']),
                  subtitle: Text(
                      "By ${snapshot.data![index]['autor']} At ${snapshot.data![index]['fecha']}"),
                  isThreeLine: true,
                  leading: Text(snapshot.data![index]['id'].toString()),
                  onTap: () =>
                      navigateToPost(context, snapshot.data![index]['id']),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Oops!"),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

void navigateToPost(BuildContext context, int idPost) async {
  dynamic post;
  await http
      .get(Uri.parse('${Global.baseApiUrl}/api/wuakalasApi/Getwuakala/$idPost'))
      .then((http.Response response) {
    post = jsonDecode(response.body);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Detalles(
          post: Post(
            id: post['id'],
            sector: post['sector'],
            descripcion: post['descripcion'],
            autor: post['autor'],
            urlFoto1: post['url_foto1'],
            urlFoto2: post['url_foto2'],
            sigueAhi: post['sigue_ahi'].toString(),
            yaNoEsta: post['ya_no_esta'].toString(),
            comentarios: post['comentarios'],
          ),
        ),
      ),
    );
  });
}

void deletePost(int idPost) async {
  await http.delete(
      Uri.parse('${Global.baseApiUrl}/api/wuakalasApi/Deletewuakalas/$idPost'));
}
