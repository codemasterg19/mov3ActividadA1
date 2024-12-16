import 'package:flutter/material.dart';
import 'package:notas/screens/administracionScreen.dart';
import 'package:notas/screens/vistaGastosScreen.dart';

class MiDrawer extends StatelessWidget {
  const MiDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFF263238), // Fondo oscuro consistente
        child: ListView(
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF37474F), Color(0xFF546E7A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  'Menú',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _buildMenuItem(
              context,
              title: "Lista de Gastos",
              icon: Icons.list,
              color: Colors.greenAccent,
              destination: const Vista(),
            ),
            _buildMenuItem(
              context,
              title: "Administrar Gastos",
              icon: Icons.note_alt,
              color: Colors.blueAccent,
              destination: const RegistroGastos(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget destination,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
        size: 30,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      tileColor: const Color(0xFF37474F),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      onTap: () {
        Navigator.pop(context); // Cierra el Drawer antes de navegar
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white,
        size: 18,
      ),
    );
  }
}
