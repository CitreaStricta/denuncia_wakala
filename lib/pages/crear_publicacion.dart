import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:denuncia_wakala/utils/utiles.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../global.dart';

class CrearPublicacion extends StatefulWidget {
  const CrearPublicacion({super.key});

  @override
  State<CrearPublicacion> createState() => _CrearPublicacionState();
}

class _CrearPublicacionState extends State<CrearPublicacion> {
  final sectorTextController = TextEditingController();
  final descripcionTextController = TextEditingController();
  final imagePicker = ImagePicker();
  late File? _image1 = null;
  late File? _image2 = null;
  String pathImage1 = '';
  String pathImage2 = '';

  Future<http.Response>? _futureMensaje;

  Future getImage(int imageNumber) async {
    final image = await imagePicker.getImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      try {
        if (imageNumber == 1) {
          _image1 ??= File(image!.path);
        } else {
          _image2 ??= File(image!.path);
        }
      } catch (e) {
        print("error");
      }
    });
  }

  Future<http.Response> crearMensaje(String sector, String descripcion,
      String rutaImg1, String rutaImg2) async {
    return await http.post(
      Uri.parse("${Global.baseApiUrl}/api/wakalasApi/Postwakalas"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'sector': sector,
        'descripcion': descripcion,
        'id_autor': Global.localId.toString(),
        'base64Foto1': await Utiles().toBase64(rutaImg1),
        'base64Foto2': await Utiles().toBase64(rutaImg2),
      }),
    );
  }

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
                  const Text("Denuncia de wakala"),
                  // burbuja de texto para el sector donde fue el avistamiento
                  TextField(
                    controller: sectorTextController,
                    decoration: InputDecoration(
                      hintText: "¿Donde ocurrió?",
                      labelText: "Sector",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // burbuja de texto para la descripcion
                  TextField(
                    controller: descripcionTextController,
                    decoration: InputDecoration(
                      hintText: "Descripción",
                      labelText: "Descripción",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    maxLines: 5,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => {getImage(1)},
                        child: Container(
                          width: 176,
                          height: 176,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: _image1 == null
                              ? Image.asset('assets/images/noimage.png')
                              : Image.file(_image1!),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {getImage(2)},
                        child: Container(
                          width: 176,
                          height: 176,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: _image2 == null
                              ? Image.asset('assets/images/noimage.png')
                              : Image.file(_image2!),
                        ),
                      )
                    ],
                  ),
                  // boton para "post"ear mensajes
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      onPressed: () {
                        if (sectorTextController.text.isEmpty) {
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.error,
                              title: 'Oops...',
                              text: 'Ingresa el sector del avistamiento',
                              loopAnimation: false);
                        } else if (descripcionTextController.text.length < 15) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: 'Oops...',
                            text: 'Descripcion de 15 o mas caracteres',
                            loopAnimation: false,
                          );
                        } else if (_image1 == null && _image2 == null) {
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: 'Oops...',
                            text: 'Ingresa al menos una imagen',
                            loopAnimation: false,
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        setState(() {
                          if (_image1 != null) pathImage1 = _image1!.path;
                          if (_image2 != null) pathImage2 = _image2!.path;

                          _futureMensaje = crearMensaje(
                              sectorTextController.text,
                              descripcionTextController.text,
                              pathImage1,
                              pathImage2);
                          Navigator.pop(context);
                        });
                      },
                      // asegurarse de que:
                      // las fotos se deben enviar en base643

                      child: const Text("Denunciar")),
                  const SizedBox(height: 10),
                  // boton por si te quieres arrepentir de hacer una publicacion
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      onPressed: () {
                        // volver a donde estabamos
                        Navigator.pop(context);
                      },
                      child: const Text("Volver")),
                ],
              ))),
    );
  }
}
