import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import 'package:proyecto_apps/features/navbar.dart';

import '../global.dart';
import '../models/post.dart';

import '../widgets/sql_helper.dart';
import 'crearPost.dart';

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
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
              builder: (context) => CrearPost(),
            ),
          );
        },
        tooltip: "Crear nota",
        child: const Icon(Icons.add_rounded),
      ),
      body: FutureBuilder<List<Post>>(
        future: SqlHelper.instance.getPosts(),
        builder: (context, snapshot) {
          //snapshot.data es la List<Post>
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data![index].title),
                  subtitle: Text(
                      "By ${snapshot.data![index].username} At ${snapshot.data![index].date}"),
                  isThreeLine: true,
                  leading: Text(snapshot.data![index].id.toString()),
                  onTap: () => navigateToPost(context, snapshot.data![index]),
                  trailing: IconButton(
                    alignment: Alignment.center,
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      SqlHelper.instance.deletePost(snapshot.data![index]);
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

void navigateToPost(BuildContext context, Post post) async {
  //Navigator.push(
  //  context,
  //  MaterialPageRoute(builder: (context) => CrearMensaje(post: post)),
  //);
}
