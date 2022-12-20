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

  bool errorUser = false;
  bool errorEmail = false;
  bool errorPass = false;
  int errorPassConfirm = 0;

  Future<void> registrarDatos(
      String email, String nombre, String password) async {
    final response = await LoginService().registrar(email, nombre, password);

    print(response.statusCode);
    if (!mounted) return;
    if (response.statusCode == 201) {
      Global.localUsername = email;
      Navigator.pop(context);
    }
  }

  Widget getPasswordConfirmTextField() {
    if (errorPassConfirm == 0) {
      return TextField(
        controller: passwordConfirmController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          hintText: "Confirme su password",
          labelText: "Confirmar password",
          suffixIcon: const Icon(Icons.lock),
        ),
      );
    } else {
      return TextField(
        onChanged: (text) {
          if (text.isNotEmpty) {
            errorPassConfirm = 0;
            setState(() {});
          }
        },
        controller: passwordConfirmController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          hintText: "Confirme su password",
          labelText: "Confirmar password",
          errorText: errorPassConfirm == 1
              ? "Confirma tu password"
              : "Las passwords deben coincidir",
          suffixIcon: const Icon(Icons.lock),
        ),
      );
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
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Spacer(),
              const Text(
                "Crea tu cuenta",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              sizedBox(30),
              TextField(
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    errorUser = false;
                    setState(() {});
                  }
                },
                controller: userController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  hintText: "Ingrese su nombre de usuario",
                  labelText: "Usuario",
                  errorText: errorUser ? "Ingresa un nombre usuario" : null,
                  suffixIcon: const Icon(Icons.person),
                ),
              ),
              sizedBox(10),
              TextField(
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    errorEmail = false;
                    setState(() {});
                  }
                },
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  hintText: "Ingrese su email",
                  labelText: "Email",
                  errorText: errorEmail ? "Ingresa un email" : null,
                  suffixIcon: const Icon(Icons.mail),
                ),
              ),
              sizedBox(10),
              TextField(
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    errorPass = false;
                    setState(() {});
                  }
                },
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  hintText: "Ingrese su password",
                  labelText: "Password",
                  errorText: errorPass ? "Crea una contraseña" : null,
                  suffixIcon: const Icon(Icons.lock),
                ),
              ),
              sizedBox(10),
              getPasswordConfirmTextField(),
              sizedBox(60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Colors.indigo,
                  shape: const StadiumBorder(),
                  minimumSize: const Size(double.infinity, 60),
                ),
                onPressed: () {
                  if (userController.text.isEmpty) {
                    errorUser = true;
                  }
                  if (emailController.text.isEmpty) {
                    errorEmail = true;
                  }
                  if (passwordController.text.isEmpty) {
                    errorPass = true;
                  }
                  if (passwordConfirmController.text.isEmpty) {
                    errorPassConfirm = 1;
                  }
                  if (passwordController.text
                          .compareTo(passwordConfirmController.text) !=
                      0) {
                    errorPassConfirm = 2;
                  }
                  if (userController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty &&
                      passwordConfirmController.text
                              .compareTo(passwordController.text) ==
                          0) {
                    registrarDatos(
                      emailController.text,
                      userController.text,
                      passwordController.text,
                    );
                  }
                  setState(() {});
                },
                child: const Text("Registrarse"),
              ),
              sizedBox(30),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Ya tengo cuenta",
                    style: TextStyle(
                      color: Colors.blue,
                      inherit: false,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
