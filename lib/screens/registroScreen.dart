import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notas/screens/loginScreen.dart';

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegistroScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
    );
  }
}

class RegistroScreen extends StatelessWidget {
  const RegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _correo = TextEditingController();
    TextEditingController _password = TextEditingController();
    TextEditingController _confirmarPassword = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),

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
                  "Crea tu cuenta",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _correo,
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
                const SizedBox(height: 20),
                TextField(
                  controller: _confirmarPassword,
                  decoration: InputDecoration(
                    labelText: "Confirmar Contraseña",
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
                  onPressed: () => registro(_correo.text, _password.text,
                      _confirmarPassword.text, context),
                  child: const Text("Registrar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> registro(email, password, confirmPassword, context) async {
  if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    // Validación de campos vacíos
    error_alert(context, 'Por favor, completa todos los campos.');
    return;
  }

  if (password != confirmPassword) {
    // Validación de contraseñas que no coinciden
    mostrarAlerta(
      context,
      "Error",
      "Las contraseñas no coinciden. Verifica e intenta nuevamente.",
      Icons.error,
      Colors.red,
    );
    return;
  }

  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Registro exitoso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usuario registrado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Login())); // Regresa a la pantalla anterior
  } on FirebaseAuthException catch (e) {
    // Manejo de errores específicos de FirebaseAuth
    switch (e.code) {
      case 'weak-password':
        error_alert(context,
            'La contraseña es demasiado débil. Intenta con una más segura.');
        break;
      case 'email-already-in-use':
        error_alert(context, 'El correo ya está en uso por otro usuario.');
        break;
      case 'invalid-email':
        error_alert(context,
            'El formato del correo no es válido. Verifica e intenta de nuevo.');
        break;
      case 'operation-not-allowed':
        error_alert(
            context, 'El registro con correo y contraseña no está habilitado.');
        break;
      default:
        error_alert(context, 'Ocurrió un error: ${e.message}');
        break;
    }
  } catch (e) {
    // Manejo de errores generales
    error_alert(context, 'Se produjo un error inesperado: ${e.toString()}');
  }
}

// Alerta personalizada
void error_alert(BuildContext context, String mensaje) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8.0),
            Text("Error", style: TextStyle(color: Colors.red)),
          ],
        ),
        content: Text(
          mensaje,
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cerrar",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      );
    },
  );
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
