import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.camera_alt, size: 80, color: Colors.blue),
            SizedBox(height: 16),
            Text(
              "Camara Turistica con Geolocalizacion",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              "Captura fotografias y guarda automaticamente la ubicacion GPS "
              "donde fueron tomadas. Revisa el historial y observa cada punto "
              "en Google Maps.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 24),
            Text("• Pestana Camara: tomar fotos."),
            Text("• Pestana Mapa: ver todas las ubicaciones."),
          ],
        ),
      ),
    );
  }
}
