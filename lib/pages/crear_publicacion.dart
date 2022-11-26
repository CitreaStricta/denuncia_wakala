import 'package:flutter/material.dart';

class CrearPublicacion extends StatelessWidget {
  const CrearPublicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // boton por si te quieres arrepentir de hacer una publicacion
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: Size(double.infinity, 60),
                      ),
                      onPressed: () {
                        // volver a donde estabamos
                        Navigator.pop(context);
                      },
                      child: Text("Me arrepenti xd")),
                ],
              ))),
    );
  }
}
