import 'package:denuncia_wakala/global.dart';
import 'package:denuncia_wakala/pages/login.dart';
import 'package:flutter/material.dart';
import '../services/login_service';
//import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final pref;

  TextEditingController userController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  Future<void> registrarDatos(
      String email, String nombre, String password) async {
    final response = await LoginService().registrar(email, nombre, password);
    print(response.statusCode);

    if (!mounted) return;
    if (response.statusCode == 200) {
      //almacenar de alguna manera el login
      Global.localUsername = nombre;
      Navigator.pop(context);
    } else {
      //text: 'Ese user ya está registrado',
    }
  }

  @override
  void initState() {
    super.initState();
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
                "Crea tu cuenta",
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
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  hintText: "Ingrese su email",
                  labelText: "Email",
                  suffixIcon: const Icon(Icons.mail),
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
              sizedBox(10),
              TextField(
                controller: passwordConfirmController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  hintText: "Confirme su password",
                  labelText: "Confirmar password",
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
                  } else if (emailController.text.isEmpty) {
                    //text: 'Debes proporcionar un email',
                  } else if (passwordController.text.isEmpty) {
                    //text: 'Debes proporcionar una password',
                  } else if (passwordConfirmController.text.isEmpty) {
                    //text: 'Debes confirmar la password',
                  } else if (!passwordController.text
                      .contains(passwordConfirmController.text)) {
                    //text: 'Las passwords deben coincidir',
                  } else {
                    registrarDatos(
                      emailController.text,
                      userController.text,
                      passwordController.text,
                    );
                  }
                },
                child: const Text("Registrarse"),
              ),
              sizedBox(30),
              GestureDetector(
                onTap: () {
                  // AQUI LA DIRECCION PARA LA PAGINA DE SIGN_UP
                },
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // AQUI TAMBIEN LA DIRECCION PARA LA PAGINA DE SIGN_UP
                  },
                  child: const Text(
                    "Ya tengo cuenta",
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
