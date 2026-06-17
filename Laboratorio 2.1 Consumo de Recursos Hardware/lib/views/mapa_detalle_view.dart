import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/foto.dart';

// Muestra en Google Maps la ubicacion de una sola fotografia.
class MapaDetalleView extends StatelessWidget {
  final Foto foto;

  const MapaDetalleView({super.key, required this.foto});

  @override
  Widget build(BuildContext context) {
    final LatLng posicion = LatLng(foto.latitud, foto.longitud);

    return Scaffold(
      appBar: AppBar(
        title: Text(foto.nombre),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: posicion, zoom: 16),
        markers: {
          Marker(
            markerId: MarkerId(foto.path),
            position: posicion,
            infoWindow: InfoWindow(
              title: foto.nombre,
              snippet: foto.coordenadas,
            ),
          ),
        },
      ),
    );
  }
}
