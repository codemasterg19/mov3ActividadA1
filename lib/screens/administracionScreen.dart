import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:notas/navigator/drawer.dart';

class RegistroGastos extends StatefulWidget {
  const RegistroGastos({super.key});

  @override
  _RegistroGastosState createState() => _RegistroGastosState();
}

class _RegistroGastosState extends State<RegistroGastos> {
  final TextEditingController _id = TextEditingController();
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _descripcion = TextEditingController();
  final TextEditingController _precio = TextEditingController();
  final TextEditingController _categoria = TextEditingController();

  bool _isEditing = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? "Editar Gasto" : "Registro de Gastos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white, // Color del ícono de hamburguesa
        ),
      ),
      drawer: MiDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.blueGrey],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _isEditing
                            ? "Edita el gasto seleccionado"
                            : "Añade un nuevo gasto",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _id,
                        label: "Código",
                        hint: "Ingresa el código del gasto",
                        enabled: !_isEditing,
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _titulo,
                        label: "Título",
                        hint: "Ingresa el título del gasto",
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _descripcion,
                        label: "Descripción",
                        hint: "Ingresa una descripción del gasto",
                        maxLines: 3,
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _precio,
                        label: "Precio",
                        hint: "Ingresa el precio del gasto",
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      _buildTextField(
                        controller: _categoria,
                        label: "Categoría",
                        hint: "Ingresa la categoría del gasto",
                      ),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_validateFields(context, _id, _titulo, _precio,
                              _descripcion, _categoria)) {
                            if (_isEditing) {
                              editar(
                                _id.text,
                                _titulo.text,
                                _descripcion.text,
                                _precio.text,
                                _categoria.text,
                              ).then((_) {
                                _showMessage(
                                  context,
                                  "Éxito",
                                  "Gasto actualizado exitosamente.",
                                  Colors.green,
                                );
                                _clearFields();
                                _cargarGastos();
                                setState(() {
                                  _isEditing = false;
                                });
                              }).catchError((error) {
                                _showMessage(
                                  context,
                                  "Error",
                                  "Hubo un error al actualizar el gasto. Inténtalo de nuevo.",
                                  Colors.red,
                                );
                              });
                            } else {
                              guardar(
                                _id.text,
                                _titulo.text,
                                _descripcion.text,
                                _precio.text,
                                _categoria.text,
                              ).then((_) {
                                _showMessage(
                                  context,
                                  "Éxito",
                                  "Gasto guardado exitosamente.",
                                  Colors.green,
                                );
                                _clearFields();
                                _cargarGastos();
                              }).catchError((error) {
                                _showMessage(
                                  context,
                                  "Error",
                                  "Hubo un error al guardar el gasto. Inténtalo de nuevo.",
                                  Colors.red,
                                );
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _isEditing ? "Actualizar" : "Guardar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      DropdownButton<String>(
                        hint: Text(
                          "Selecciona un gasto para editar",
                          style: TextStyle(color: Colors.white),
                        ),
                        dropdownColor: Colors.grey[900],
                        value: null,
                        items: _gastos.map((gasto) {
                          return DropdownMenuItem<String>(
                            value: gasto["id"],
                            child: Text(
                              gasto["titulo"],
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? id) {
                          final gasto =
                              _gastos.firstWhere((g) => g["id"] == id);
                          cargarDatosParaEditar(
                            gasto["id"],
                            gasto["titulo"],
                            gasto["descripcion"],
                            gasto["precio"],
                            gasto["categoria"],
                          );
                        },
                      ),
                      if (_isEditing)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          icon: Icon(Icons.delete, color: Colors.white),
                          label: Text(
                            "Eliminar Gasto",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Confirmar Eliminación"),
                                  content: Text(
                                      "¿Estás seguro de que deseas eliminar este gasto?"),
                                  actions: [
                                    TextButton(
                                      child: Text("Cancelar"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Eliminar",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      onPressed: () {
                                        eliminar(_id.text).then((_) {
                                          Navigator.of(context).pop();
                                          _showMessage(
                                            context,
                                            "Éxito",
                                            "Gasto eliminado exitosamente.",
                                            Colors.green,
                                          );
                                          _clearFields();
                                          _cargarGastos();
                                          setState(() {
                                            _isEditing = false;
                                          });
                                        }).catchError((error) {
                                          Navigator.of(context).pop();
                                          _showMessage(
                                            context,
                                            "Error",
                                            "Hubo un error al eliminar el gasto. Inténtalo de nuevo.",
                                            Colors.red,
                                          );
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      ),
      style: TextStyle(color: Colors.white),
    );
  }

  bool _validateFields(
    BuildContext context,
    TextEditingController id,
    TextEditingController titulo,
    TextEditingController precio,
    TextEditingController descripcion,
    TextEditingController categoria,
  ) {
    if (id.text.isEmpty ||
        titulo.text.isEmpty ||
        precio.text.isEmpty ||
        descripcion.text.isEmpty ||
        categoria.text.isEmpty) {
      _showMessage(
        context,
        "Error",
        "Por favor, completa todos los campos obligatorios.",
        Colors.red,
      );
      return false;
    }
    return true;
  }

  void _clearFields() {
    _id.clear();
    _titulo.clear();
    _descripcion.clear();
    _precio.clear();
    _categoria.clear();
  }

  void _showMessage(
      BuildContext context, String title, String message, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(
                color == Colors.green ? Icons.check_circle : Icons.error,
                color: color,
              ),
              SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              child: Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> eliminar(String id) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("gastos/$id");
    await ref.remove();
  }

  Future<void> guardar(String id, String titulo, String descripcion,
      String precio, String categoria) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("gastos/$id");
    await ref.set({
      "titulo": titulo,
      "descripcion": descripcion,
      "precio": precio,
      "categoria": categoria,
    });
  }

  Future<void> editar(String id, String titulo, String descripcion,
      String precio, String categoria) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("gastos/$id");
    await ref.update({
      "titulo": titulo,
      "descripcion": descripcion,
      "precio": precio,
      "categoria": categoria,
    });
  }

  void cargarDatosParaEditar(String id, String titulo, String descripcion,
      String precio, String categoria) {
    setState(() {
      _isEditing = true;
      _id.text = id;
      _titulo.text = titulo;
      _descripcion.text = descripcion;
      _precio.text = precio;
      _categoria.text = categoria;
    });
  }
}
