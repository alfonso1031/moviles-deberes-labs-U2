import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/foto_controller.dart';
import '../providers/foto_provider.dart';
import '../widgets/foto_item.dart';

class FotoView extends StatelessWidget {
  const FotoView({super.key});

  @override
  Widget build(BuildContext context) {
    // Se instancia el provider y el controlador (inyeccion de dependencias).
    final provider = Provider.of<FotoProvider>(context);
    final controller = FotoController(provider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Camara Turistica"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: provider.fotos.isEmpty
          ? const Center(
              child: Text("Aun no hay fotografias.\nToca la camara para empezar."),
            )
          : ListView.builder(
              itemCount: provider.fotos.length,
              itemBuilder: (_, index) {
                return FotoItem(foto: provider.fotos[index]);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => controller.tomarFoto(context),
        icon: const Icon(Icons.camera_alt),
        label: const Text("Tomar foto"),
      ),
    );
  }
}
