import 'dart:convert';

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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  int errorUsername = 0;
  int errorPassword = 0;

  Future<void> intentarLogin(String user, String password) async {
    final response = await LoginService().validar(user, password);

    if (response.statusCode == 200) {
      //almacenar de alguna manera el login
      final dynamic data = jsonDecode(response.body);
      Global.localUsername = data['nombre'];
      Global.localId = data["id"];
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Lista(),
        ),
      );
    } else {
      errorUsername = 2;
      errorPassword = 2;
      setState(() {});
    }
  }

  Widget usernameField() {
    if (errorUsername == 1) {
      return TextField(
        onChanged: (text) {
          if (text.isNotEmpty) {
            errorUsername = 0;
            setState(() {});
          }
        },
        controller: emailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          hintText: "Ingrese su email",
          labelText: "Email",
          errorText: "Debes proporcionar un email",
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.mail),
          ),
        ),
      );
    } else if (errorPassword == 2) {
      return TextField(
        controller: emailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          hintText: "Ingrese su email",
          labelText: "Email",
          errorText: "Email erroneo o",
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.mail),
          ),
        ),
      );
    } else {
      return TextField(
        controller: emailController,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          hintText: "Ingrese su email",
          labelText: "Email",
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.mail),
          ),
        ),
      );
    }
  }

  Widget passwordField() {
    if (errorPassword == 1) {
      return TextField(
        onChanged: (text) {
          if (text.isNotEmpty) {
            errorPassword = 0;
            setState(() {});
          }
        },
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          hintText: "Ingrese su password",
          labelText: "Password",
          errorText: "Debes proporcionar una contraseña",
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.lock),
          ),
        ),
      );
    } else if (errorPassword == 2) {
      return TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          hintText: "Ingrese su password",
          labelText: "Password",
          errorText: "Contraseña erronea",
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.lock),
          ),
        ),
      );
    } else {
      return TextField(
        controller: passwordController,
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          hintText: "Ingrese su password",
          labelText: "Password",
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.lock),
          ),
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
              const Text(
                "Denuncia Wuakala",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Text(
                "Inicia sesión",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              sizedBox(20),
              usernameField(),
              sizedBox(10),
              passwordField(),
              sizedBox(20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // backgroundColor: Colors.indigo,
                  shape: const StadiumBorder(),
                  minimumSize: const Size(double.infinity, 60),
                ),
                onPressed: () {
                  if (emailController.text.isEmpty) {
                    errorUsername = 1;
                    if (passwordController.text.isEmpty) {
                      errorPassword = 1;
                    }
                    setState(() {});
                  } else if (passwordController.text.isEmpty) {
                    errorPassword = 1;
                    setState(() {});
                  } else {
                    errorUsername = 0;
                    errorPassword = 0;
                    setState(() {});
                    intentarLogin(
                      emailController.text,
                      passwordController.text,
                    );
                  }
                },
                child: const Text("Acceder"),
              ),
              sizedBox(20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Register(),
                    ),
                  );
                },
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Register(),
                      ),
                    );
                  },
                  child: const Text(
                    "Crear una cuenta",
                    style: TextStyle(
                      color: Colors.blue,
                      inherit: false,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Spacer(),
                  Column(
                    children: const [
                      Text(
                        "Por: ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Vicente 'Chulz' Schultz",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        "Nicolas 'Zso' Rojas",
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                  const Spacer()
                ],
              ),
              const Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
