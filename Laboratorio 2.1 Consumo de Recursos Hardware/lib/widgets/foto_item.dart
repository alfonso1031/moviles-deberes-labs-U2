import 'dart:io';
import 'package:flutter/material.dart';
import '../models/foto.dart';
import '../views/mapa_detalle_view.dart';

class FotoItem extends StatelessWidget {
  final Foto foto;

  const FotoItem({super.key, required this.foto});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(foto.path),
            width: 56,
            height: 56,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(foto.nombre),
        subtitle: Text(foto.coordenadas),
        trailing: IconButton(
          icon: const Icon(Icons.map, color: Colors.blue),
          tooltip: "Ver en el mapa",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MapaDetalleView(foto: foto),
              ),
            );
          },
        ),
      ),
    );
  }
}
