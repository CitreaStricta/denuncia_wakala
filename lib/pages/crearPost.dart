import 'package:flutter/material.dart';

import '../global.dart';
import '../pages/login.dart';
import '../models/post.dart';
import '../widgets/sql_helper.dart';

class CrearPost extends StatefulWidget {
  static const routeName2 = '/detailPostScreen';
  final Post? post;

  const CrearPost({Key? key, this.post}) : super(key: key);

  @override
  State<CrearPost> createState() => _CrearPostState(post);
}

class _CrearPostState extends State<CrearPost> {
  Post? post;
  final titleTextController = TextEditingController();
  final textTextController = TextEditingController();

  _CrearPostState(this.post);

  @override
  void initState() {
    super.initState();
    if (post != null) {
      titleTextController.text = post!.title;
      textTextController.text = post!.text;
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleTextController.dispose();
    textTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva publicación'),
      ),
      body: Column(
        children: <Widget>[
          // area de titulo
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  labelText: "Título"),
              maxLines: 1,
              controller: titleTextController,
            ),
          ),
          // area de texto (descripcion)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16.0))),
                  labelText: "Descripción"),
              maxLines: 10,
              controller: textTextController,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.check),
          onPressed: () async {
            if (titleTextController.text.isEmpty) {
              var snackBar =
                  const SnackBar(content: Text('Debe ingresar el título'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              if (textTextController.text.isEmpty) {
                var snackBar = const SnackBar(
                    content: Text('Debe ingresar la descripción'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                savePost(titleTextController.text, textTextController.text);
                setState(() {});
              }
            }
          }),
    );
  }

  savePost(String title, String text) async {
    if (post == null) {
      SqlHelper.instance.insertPost(Post(
        title: titleTextController.text,
        text: textTextController.text,
        username: Global.localUsername,
      ));
      Navigator.pop(context, "Tu publicación se creó con éxito.");
    } else {
      await SqlHelper.instance.updatePost(Post(
        id: post?.id,
        username: Global.localUsername,
        title: title,
        text: text,
      ));
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
