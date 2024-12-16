import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notas/screens/vistaGastosScreen.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _email = TextEditingController();
    TextEditingController _password = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: const Color(0xFF37474F), // Azul grisáceo oscuro
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF263238), // Azul grisáceo oscuro
              Color(0xFF455A64), // Azul grisáceo medio
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Inicia sesión",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _email,
                  decoration: InputDecoration(
                    labelText: "Correo Electrónico",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(
                        255, 155, 214, 241), // Azul grisáceo claro
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    textStyle:
                        const TextStyle(fontSize: 18.0, color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () => login(_email.text, _password.text, context),
                  child: const Text("Ingresar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> login(email, pass, context) async {
  if (email.isEmpty || pass.isEmpty) {
    mostrarAlerta(context, "Error", "Por favor, completa todos los campos.",
        Icons.error, Colors.red);
    return;
  }

  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: pass,
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Vista()),
    );
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      mostrarAlerta(
        context,
        "Error",
        "Usuario no encontrado.",
        Icons.error,
        Colors.red,
      );
    } else if (e.code == 'wrong-password') {
      mostrarAlerta(
        context,
        "Error",
        "Contraseña incorrecta.",
        Icons.error,
        Colors.red,
      );
    } else {
      // Manejo genérico de excepciones específicas de FirebaseAuth
      mostrarAlerta(
        context,
        "Error",
        "Error de autenticación: ${e.message}",
        Icons.error,
        Colors.red,
      );
    }
  } catch (e) {
    // Manejo de errores generales
    mostrarAlerta(
      context,
      "Error",
      "Ha ocurrido un error. Inténtalo de nuevo.",
      Icons.error,
      Colors.red,
    );
  }
}

void mostrarAlerta(BuildContext context, String titulo, String mensaje,
    IconData icono, Color colorIcono) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey[900], // Fondo oscuro para el diálogo
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(icono, color: colorIcono),
            SizedBox(width: 8),
            Text(
              titulo,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          mensaje,
          style: TextStyle(color: Colors.grey[300]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              "Cerrar",
              style: TextStyle(
                  color: Colors.blueAccent, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      );
    },
  );
}
