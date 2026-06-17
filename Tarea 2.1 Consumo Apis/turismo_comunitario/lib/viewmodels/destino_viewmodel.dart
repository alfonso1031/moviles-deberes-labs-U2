import 'package:flutter/material.dart';
import '../models/destino.dart';
import '../services/destino_service.dart';

class DestinoViewModel extends ChangeNotifier {
  final DestinoService service;

  DestinoViewModel({required this.service});

  List<Destino> destinos = [];
  bool loading = false;
  String? errorMessage;

  Future<void> cargar() async {
    loading = true;
    errorMessage = null;
    notifyListeners();
    try {
      destinos = await service.listar();
    } catch (e) {
      errorMessage = "Error de conexion: $e";
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<bool> crear(Destino d) async {
    try {
      await service.crear(d);
      await cargar();
      return true;
    } catch (e) {
      errorMessage = "$e";
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizar(int id, Destino d) async {
    try {
      await service.actualizar(id, d);
      await cargar();
      return true;
    } catch (e) {
      errorMessage = "$e";
      notifyListeners();
      return false;
    }
  }

  Future<String?> eliminar(int id) async {
    try {
      await service.eliminar(id);
      await cargar();
      return null;
    } catch (e) {
      return e.toString().replaceFirst("Exception: ", "");
    }
  }
}
