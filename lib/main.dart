import 'package:denuncia_wakala/pages/lista_publicaciones.dart';
import 'package:flutter/material.dart';
import 'package:denuncia_wakala/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ListaPublicaciones());
  }
}
