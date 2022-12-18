import 'package:denuncia_wakala/global.dart';
import 'package:denuncia_wakala/pages/register.dart';
import 'package:flutter/material.dart';

import '../services/login_service';
import 'lista.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final pref;

  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> intentarLogin(String user, String password) async {
    final response = await LoginService().validar(user, password);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //almacenar de alguna manera el login
      //await pref.setString('Usuario', user);
      Global.localUsername = user;
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Lista(),
        ),
      );
    }
  }

  void recoverPassword(String user) {
    //LoginService().recovery(user, context);
  }

  String? login_guardado = "";

  @override
  void initState() {
    super.initState();
    cargaPreferencia();
  }

  void cargaPreferencia() async {
    //pref = await SharedPreferences.getInstance();
    //login_guardado = pref.getString("Usuario");
    //userController.text = login_guardado == null ? "" : login_guardado!;
  }

  SizedBox sizedBox(double height) {
    return SizedBox(height: height);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Inicia sesión",
                textScaleFactor: 1.2,
              ),
              sizedBox(30),
              TextField(
                controller: userController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  hintText: "Ingrese su nombre de usuario",
                  labelText: "Usuario",
                  suffixIcon: const Icon(Icons.person),
                ),
              ),
              sizedBox(10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  hintText: "Ingrese su password",
                  labelText: "Password",
                  suffixIcon: const Icon(Icons.lock),
                ),
              ),
              sizedBox(60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Colors.indigo,
                  shape: const StadiumBorder(),
                  minimumSize: const Size(double.infinity, 60),
                ),
                onPressed: () {
                  if (userController.text.isEmpty) {
                    //text: 'Debes proporcionar un nombre de usuario',
                  } else if (passwordController.text.isEmpty) {
                    //text: 'Debes proporcionar una password',
                  } else {
                    intentarLogin(
                      userController.text,
                      passwordController.text,
                    );
                  }
                },
                child: const Text("Acceder"),
              ),
              sizedBox(30),
              GestureDetector(
                onLongPress: () {
                  print("Longpress");
                },
                onTap: () {
                  print("hola");
                },
                child: TextButton(
                  onPressed: () {
                    if (userController.text.isEmpty) {
                      //text: 'Debes proporcionar un nombre de usuario',
                    } else {
                      recoverPassword(userController.text);
                    }
                  },
                  // AQUI TAMBIEN LA DIRECCION PARA LA PAGINA DE SIGN_UP
                  child: const Text(
                    "¿Olvido su password?",
                    style: TextStyle(
                      color: Colors.blue,
                      inherit: false,
                    ),
                  ),
                ),
              ),
              sizedBox(5),
              GestureDetector(
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Register(),
                      ),
                    );
                    // AQUI TAMBIEN LA DIRECCION PARA LA PAGINA DE SIGN_UP
                  },
                  child: const Text(
                    "Crear una cuenta",
                    style: TextStyle(
                      color: Colors.blue,
                      inherit: false,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
