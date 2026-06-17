import 'package:flutter/material.dart';
import '../models/foto.dart';

class FotoProvider extends ChangeNotifier {
  // Historial de fotografias capturadas con su ubicacion.
  final List<Foto> _fotos = [];

  List<Foto> get fotos => _fotos;

  void agregarFoto(Foto foto) {
    _fotos.add(foto);
    notifyListeners();
  }
}
