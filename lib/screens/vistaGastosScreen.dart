import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notas/navigator/drawer.dart';

class Vista extends StatefulWidget {
  const Vista({super.key});

  @override
  _VistaState createState() => _VistaState();
}

class _VistaState extends State<Vista> {
  List<Map<String, dynamic>> _gastos = [];

  @override
  void initState() {
    super.initState();
    _cargarGastos();
  }

  Future<void> _cargarGastos() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("gastos/");
    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        _gastos = data.entries.map((entry) {
          return {
            "id": entry.key,
            ...Map<String, dynamic>.from(entry.value),
          };
        }).toList();
      });
    }
  }

  void _mostrarDetalles(BuildContext context, Map<String, dynamic> gasto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900], // Fondo oscuro del modal
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Detalles del Gasto",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Título: ${gasto['titulo']}",
                  style: TextStyle(color: Colors.grey[300])),
              Text("Descripción: ${gasto['descripcion']}",
                  style: TextStyle(color: Colors.grey[300])),
              Text("Precio: \$${gasto['precio']}",
                  style: TextStyle(color: Colors.grey[300])),
              Text("Categoría: ${gasto['categoria']}",
                  style: TextStyle(color: Colors.grey[300])),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cerrar",
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gastos',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF37474F), // Fondo gris oscuro
        iconTheme: const IconThemeData(color: Colors.white), // Ícono blanco
      ),
      drawer: const MiDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF263238), Color(0xFF455A64)], // Degradado gris
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _gastos.isEmpty
            ? const Center(
                child: Text(
                  "No hay gastos registrados.",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _gastos.length,
                itemBuilder: (context, index) {
                  final gasto = _gastos[index];
                  return Card(
                    color: Colors.grey[850], // Fondo de la tarjeta
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        gasto["titulo"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Precio: \$${gasto['precio']}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          _mostrarDetalles(context, gasto);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Detalle",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
