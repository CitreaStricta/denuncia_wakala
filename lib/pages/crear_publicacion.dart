import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';

class CrearPublicacion extends StatelessWidget {
  CrearPublicacion({super.key});

  final sectorTextController = TextEditingController();
  final descripcionTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // texto de mas arriba
                  const Text("Avisar por nuevo Gato"),
                  // burbuja de texto para el sector donde fue el avistamiento
                  TextField(
                    controller: sectorTextController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Donde ocurrio?",
                      labelText: "Sector",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                  ),
                  // burbuja de texto para la descripcion
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: descripcionTextController,
                      decoration: const InputDecoration(
                        hintText: "Descripcion",
                        labelText: "Descripción",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        ),
                      ),
                      maxLines: 5,
                    ),
                  ),
                  // boton para "post"ear mensajes
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      onPressed: () {
                        if (sectorTextController.toString().isEmpty) {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: 'Ingresa el sector del avistamiento');
                        }
                        if (sectorTextController.toString().length < 15) {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              text: 'asdf');
                        }
                        // asegurarse de que:
                        // el campo "sector" tenga contenido
                        // el campo "Descripcion" tenga un minimo de 15 chars
                        // que se envie al menos una foto
                        // las fotos se deben enviar en base643
                        Navigator.pop(context);
                      },
                      child: const Text("Denunciar Gato")),
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
