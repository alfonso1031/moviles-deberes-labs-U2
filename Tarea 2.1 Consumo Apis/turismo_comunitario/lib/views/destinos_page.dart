import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/destino_viewmodel.dart';
import '../widgets/destino_card.dart';
import 'detalle_page.dart';

class DestinosPage extends StatefulWidget {
  const DestinosPage({super.key});

  @override
  State<DestinosPage> createState() => _DestinosPageState();
}

class _DestinosPageState extends State<DestinosPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<DestinoViewModel>().cargar());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DestinoViewModel>();

    if (vm.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(vm.errorMessage!, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: vm.cargar,
              icon: const Icon(Icons.refresh),
              label: const Text("Reintentar"),
            ),
          ],
        ),
      );
    }
    if (vm.destinos.isEmpty) {
      return const Center(child: Text("No hay destinos registrados"));
    }

    return RefreshIndicator(
      onRefresh: vm.cargar,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: vm.destinos.length,
        itemBuilder: (_, i) => DestinoCard(
          destino: vm.destinos[i],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetallePage(destino: vm.destinos[i]),
            ),
          ).then((_) => vm.cargar()),
        ),
      ),
    );
  }
}
