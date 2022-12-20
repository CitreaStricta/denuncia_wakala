import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:denuncia_wakala/utils/utiles.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
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

  bool errorSector = false;
  int errorDescripcion = 0;
  bool errorFotos = false;

  final imagePicker = ImagePicker();
  late File? _image1 = null;
  late File? _image2 = null;
  String pathImage1 = '';
  String pathImage2 = '';

  Future<http.Response>? _futureMensaje;

  Future getImage(int imageNumber) async {
    errorFotos = false;
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
      Uri.parse("${Global.baseApiUrl}/api/wuakalasApi/Postwuakalas"),
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

  Widget getSectorTextField() {
    if (!errorSector) {
      return TextField(
        controller: sectorTextController,
        decoration: InputDecoration(
          hintText: "¿Donde ocurrió?",
          labelText: "Sector",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      );
    } else {
      return TextField(
        onChanged: (text) {
          if (text.isNotEmpty) {
            errorSector = false;
            setState(() {});
          }
        },
        controller: sectorTextController,
        decoration: InputDecoration(
          hintText: "¿Donde ocurrió?",
          labelText: "Sector",
          errorText: "Ingresa el sector del avistamiento",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      );
    }
  }

  Widget getDescripcionTextField() {
    if (errorDescripcion == 0) {
      return TextField(
        controller: descripcionTextController,
        decoration: InputDecoration(
          hintText: "Descripción",
          labelText: "Descripción",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
        maxLines: 5,
      );
    } else if (errorDescripcion == 1) {
      return TextField(
        onChanged: (text) {
          if (text.isNotEmpty) {
            errorDescripcion = 0;
            setState(() {});
          }
        },
        controller: descripcionTextController,
        decoration: InputDecoration(
          hintText: "Descripción",
          labelText: "Descripción",
          errorText: "Ingresa una descripción",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
        maxLines: 5,
      );
    } else {
      return TextField(
        onChanged: (text) {
          if (text.isNotEmpty) {
            errorDescripcion = 0;
            setState(() {});
          }
        },
        controller: descripcionTextController,
        decoration: InputDecoration(
          hintText: "Descripción",
          labelText: "Descripción",
          errorText: "La descripción debe ser de 15 caracteres o más",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
        maxLines: 5,
      );
    }
  }

  Widget getFotoErrorMessage() {
    if (!errorFotos) {
      return const SizedBox(height: 36);
    } else {
      return Column(
        children: const [
          SizedBox(height: 20),
          Text(
            'Debes adjuntar al menos una imagen',
            style: TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: BackButton(),
                      ),
                      // parsear el SECTOR aqui con los datos de la api
                      Flexible(
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            "Denunciar wuakala",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 54),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // burbuja de texto para el sector donde fue el avistamiento
                  getSectorTextField(),

                  const SizedBox(height: 10),
                  // burbuja de texto para la descripcion
                  getDescripcionTextField(),

                  getFotoErrorMessage(),

                  Row(children: [
                    const Spacer(),
                    const Spacer(),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            if (_image1 != null)
                              {
                                showImageViewer(
                                    context, Image.file(_image1!).image,
                                    swipeDismissible: false)
                              }
                            else
                              {getImage(1)}
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.25,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: _image1 == null
                                    ? Image.asset('assets/images/noimage.png')
                                    : Image.file(_image1!),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.3, 60),
                            ),
                            onPressed: () {
                              // volver a donde estabamos
                              _image1 = null;
                              Image.asset('assets/images/noimage.png');

                              setState(() {});
                            },
                            child: const Text("Borrar")),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => {
                            if (_image2 != null)
                              {
                                showImageViewer(
                                    context, Image.file(_image2!).image,
                                    swipeDismissible: false)
                              }
                            else
                              {
                                getImage(2),
                              }
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.4,
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.4,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                child: _image2 == null
                                    ? Image.asset('assets/images/noimage.png')
                                    : Image.file(_image2!),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              minimumSize: Size(
                                  MediaQuery.of(context).size.width * 0.3, 60),
                            ),
                            onPressed: () {
                              // volver a donde estabamos
                              _image2 = null;
                              Image.asset('assets/images/noimage.png');

                              setState(() {});
                            },
                            child: const Text("Borrar")),
                      ],
                    ),
                    const Spacer(),
                    const Spacer(),
                  ]),
                  const SizedBox(
                    height: 10,
                  ),
                  // boton para "post"ear mensajes
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      minimumSize: const Size(double.infinity, 60),
                    ),
                    onPressed: () {
                      if (sectorTextController.text.isEmpty) {
                        errorSector = true;
                        if (descripcionTextController.text.length < 15) {
                          if (descripcionTextController.text.isEmpty) {
                            errorDescripcion = 1;
                          } else {
                            errorDescripcion = 2;
                          }
                          if (_image1 == null && _image2 == null) {
                            errorFotos = true;
                          }
                        }
                        setState(() {});
                      } else if (descripcionTextController.text.length < 15) {
                        if (descripcionTextController.text.isEmpty) {
                          errorDescripcion = 1;
                        } else {
                          errorDescripcion = 2;
                        }
                        setState(() {});
                      } else if (_image1 == null && _image2 == null) {
                        errorFotos = true;
                        setState(() {});
                      } else {
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
                      }
                    },
                    // asegurarse de que:
                    // las fotos se deben enviar en base643
                    child: const Text("Denunciar"),
                  ),
                ],
              ))),
    );
  }
}
