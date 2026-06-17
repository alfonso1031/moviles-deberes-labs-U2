import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../providers/foto_provider.dart';

// Mapa general: muestra un marcador por cada fotografia del historial.
class MapaView extends StatelessWidget {
  const MapaView({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FotoProvider>(context);

    if (provider.fotos.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Mapa"),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Text("Toma una foto para verla en el mapa."),
        ),
      );
    }

    // Construye un marcador por cada foto registrada.
    final markers = provider.fotos
        .map(
          (foto) => Marker(
            markerId: MarkerId(foto.path),
            position: LatLng(foto.latitud, foto.longitud),
            infoWindow: InfoWindow(
              title: foto.nombre,
              snippet: foto.coordenadas,
            ),
          ),
        )
        .toSet();

    // Centra la camara en la ultima foto tomada.
    final ultima = provider.fotos.last;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de Fotografias"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(ultima.latitud, ultima.longitud),
          zoom: 14,
        ),
        markers: markers,
      ),
    );
  }
}
