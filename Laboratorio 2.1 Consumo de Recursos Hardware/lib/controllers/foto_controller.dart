import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../models/foto.dart';
import '../providers/foto_provider.dart';

class FotoController {
  // Inyeccion de dependencias: el controlador recibe el provider.
  final FotoProvider provider;
  final ImagePicker picker = ImagePicker();

  FotoController(this.provider);

  // Flujo completo: pide permisos GPS, captura la foto y obtiene la ubicacion.
  Future<void> tomarFoto(BuildContext context) async {
    // 1. Verificar permisos y servicio de ubicacion antes de la camara.
    final Position? posicion = await _obtenerUbicacion(context);
    if (posicion == null) return;

    // 2. Abrir la camara del dispositivo.
    final XFile? foto = await picker.pickImage(source: ImageSource.camera);
    if (foto == null) return;

    // 3. Guardar la foto junto con su latitud y longitud.
    provider.agregarFoto(
      Foto(
        path: foto.path,
        nombre: "Foto ${provider.fotos.length + 1}",
        latitud: posicion.latitude,
        longitud: posicion.longitude,
        fecha: DateTime.now(),
      ),
    );

    if (!context.mounted) return;
    _mostrarMensaje(context, "Foto guardada con su ubicacion GPS");
  }

  // Maneja el servicio de ubicacion y los permisos de geolocalizacion.
  Future<Position?> _obtenerUbicacion(BuildContext context) async {
    final bool servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      if (context.mounted) {
        _mostrarMensaje(context, "Activa el GPS para continuar");
      }
      return null;
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      if (context.mounted) {
        _mostrarMensaje(context, "Permiso de ubicacion denegado");
      }
      return null;
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  void _mostrarMensaje(BuildContext context, String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
