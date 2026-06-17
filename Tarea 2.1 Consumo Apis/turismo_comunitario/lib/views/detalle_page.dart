import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/destino.dart';
import '../models/reserva.dart';
import '../viewmodels/destino_viewmodel.dart';
import '../viewmodels/reserva_viewmodel.dart';
import '../widgets/reserva_card.dart';
import 'destino_form_page.dart';

class DetallePage extends StatefulWidget {
  final Destino destino;

  const DetallePage({super.key, required this.destino});

  @override
  State<DetallePage> createState() => _DetallePageState();
}

class _DetallePageState extends State<DetallePage> {
  late Destino _destino;
  final _nombreCtrl = TextEditingController();
  final _personasCtrl = TextEditingController();
  DateTime? _fecha;

  @override
  void initState() {
    super.initState();
    _destino = widget.destino;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReservaViewModel>().cargarPorDestino(_destino.id);
    });
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _personasCtrl.dispose();
    super.dispose();
  }

  Future<void> _formularioReserva({Reserva? existente}) async {
    if (existente != null) {
      _nombreCtrl.text = existente.nombreTurista;
      _personasCtrl.text = existente.numPersonas.toString();
      _fecha = DateTime.tryParse(existente.fecha);
    } else {
      _nombreCtrl.clear();
      _personasCtrl.clear();
      _fecha = null;
    }
    final editando = existente != null;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(editando ? "Editar reserva" : "Registrar reserva",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nombreCtrl,
                    decoration: const InputDecoration(
                      labelText: "Nombre del turista",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _personasCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Numero de personas",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () async {
                      final hoy = DateTime.now();
                      final f = await showDatePicker(
                        context: ctx,
                        initialDate: hoy,
                        firstDate: hoy,
                        lastDate: DateTime(2100),
                      );
                      if (f != null) setSheet(() => _fecha = f);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Fecha de la reserva",
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                        border: OutlineInputBorder(),
                      ),
                      child: Text(_fecha == null
                          ? "Seleccionar fecha"
                          : _fecha!.toIso8601String().substring(0, 10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => _enviarReserva(ctx, existente),
                      child: Text(editando ? "Guardar cambios" : "Reservar"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _enviarReserva(BuildContext sheetCtx, Reserva? existente) async {
    final messenger = ScaffoldMessenger.of(context);
    final sheetNav = Navigator.of(sheetCtx);
    final nombre = _nombreCtrl.text.trim();
    final personas = int.tryParse(_personasCtrl.text);

    if (nombre.isEmpty || personas == null || personas < 1 || _fecha == null) {
      ScaffoldMessenger.of(sheetCtx).showSnackBar(const SnackBar(
        content: Text("Complete todos los campos correctamente"),
      ));
      return;
    }

    final vm = context.read<ReservaViewModel>();
    final reserva = Reserva(
      id: existente?.id ?? 0,
      destinoId: _destino.id,
      nombreTurista: nombre,
      fecha: _fecha!.toIso8601String().substring(0, 10),
      numPersonas: personas,
    );

    final error = existente == null
        ? await vm.crear(reserva)
        : await vm.actualizar(existente.id, reserva);
    if (!mounted) return;
    sheetNav.pop();
    messenger.showSnackBar(SnackBar(
      content: Text(error ??
          (existente == null ? "Reserva registrada" : "Reserva actualizada")),
    ));
  }

  Future<void> _eliminarDestino() async {
    final messenger = ScaffoldMessenger.of(context);
    final vm = context.read<DestinoViewModel>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar destino"),
        content: const Text("Esta seguro de eliminar este destino?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar")),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Eliminar")),
        ],
      ),
    );
    if (ok != true) return;

    final error = await vm.eliminar(_destino.id);
    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context);
    } else {
      messenger.showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rvm = context.watch<ReservaViewModel>();
    final dvm = context.read<DestinoViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(_destino.nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DestinoFormPage(destino: _destino),
              ),
            ).then((_) async {
              await dvm.cargar();
              final actualizado =
                  dvm.destinos.where((d) => d.id == _destino.id).firstOrNull;
              if (actualizado != null && mounted) {
                setState(() => _destino = actualizado);
              }
            }),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: scheme.error),
            onPressed: _eliminarDestino,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.landscape,
                size: 80, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 20),
          Text(_destino.nombre,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.place_outlined,
                  size: 18, color: scheme.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(_destino.comunidad,
                  style: TextStyle(color: scheme.onSurfaceVariant)),
              const Spacer(),
              Text("\$${_destino.precio.toStringAsFixed(2)} / persona",
                  style: TextStyle(
                      color: scheme.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(_destino.descripcion),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Reservas",
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text("${rvm.reservas.length}",
                  style: TextStyle(color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 8),
          if (rvm.loading)
            const Center(child: CircularProgressIndicator())
          else if (rvm.reservas.isEmpty)
            const Text("Sin reservas aun",
                style: TextStyle(color: Colors.grey))
          else
            ...rvm.reservas.map((r) => ReservaCard(
                  reserva: r,
                  onEditar: () => _formularioReserva(existente: r),
                  onEliminar: () => rvm.eliminar(r.id, _destino.id),
                )),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _formularioReserva,
        icon: const Icon(Icons.add),
        label: const Text("Reservar"),
      ),
    );
  }
}
