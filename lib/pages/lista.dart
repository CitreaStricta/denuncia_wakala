import 'dart:convert';

import 'package:denuncia_wakala/pages/crear_publicacion.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../global.dart';
import '../models/post.dart';

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  Future<List<dynamic>> getPosts() async {
    List<dynamic> data = [];
    await http
        .get(Uri.parse('${Global.baseApiUrl}/api/wuakalasApi/Getwakalas'))
        .then((http.Response response) {
      data = jsonDecode(response.body);
    });
    return data;
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
        tooltip: "Crear nota",
        child: const Icon(Icons.add_rounded),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: getPosts(),
        builder: (context, snapshot) {
          //snapshot.data es la List<dynamic>
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data![index]['sector']),
                  subtitle: Text(
                      "By ${snapshot.data![index]['autor']} At ${snapshot.data![index]['fecha']}"),
                  isThreeLine: true,
                  leading: Text(snapshot.data![index]['id'].toString()),
                  onTap: () => navigateToPost(context, snapshot.data![index]),
                  trailing: IconButton(
                    alignment: Alignment.center,
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      deletePost(snapshot.data![index]['id']);
                      // setState(() {});
                    },
                  ),
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
      .get(Uri.parse('${Global.baseApiUrl}/api/wuakalasApi/Getwakala/$idPost'))
      .then((http.Response response) {
    post = jsonDecode(response.body);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Detalles(post: post)),
    );
  });
}

void deletePost(int idPost) async {
  await http.delete(
      Uri.parse('${Global.baseApiUrl}/api/wuakalasApi/Deletewakalas/$idPost'));
}
