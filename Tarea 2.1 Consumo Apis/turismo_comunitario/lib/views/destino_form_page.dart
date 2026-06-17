import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/destino.dart';
import '../viewmodels/destino_viewmodel.dart';

class DestinoFormPage extends StatefulWidget {
  final Destino? destino;

  const DestinoFormPage({super.key, this.destino});

  @override
  State<DestinoFormPage> createState() => _DestinoFormPageState();
}

class _DestinoFormPageState extends State<DestinoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _comunidadCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _precioCtrl = TextEditingController();
  bool _guardando = false;

  @override
  void initState() {
    super.initState();
    final d = widget.destino;
    if (d != null) {
      _nombreCtrl.text = d.nombre;
      _comunidadCtrl.text = d.comunidad;
      _descCtrl.text = d.descripcion;
      _precioCtrl.text = d.precio.toString();
    }
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _comunidadCtrl.dispose();
    _descCtrl.dispose();
    _precioCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _guardando = true);

    final vm = context.read<DestinoViewModel>();
    final nuevo = Destino(
      id: widget.destino?.id ?? 0,
      nombre: _nombreCtrl.text.trim(),
      comunidad: _comunidadCtrl.text.trim(),
      descripcion: _descCtrl.text.trim(),
      precio: double.parse(_precioCtrl.text),
    );

    bool ok;
    if (widget.destino == null) {
      ok = await vm.crear(nuevo);
    } else {
      ok = await vm.actualizar(widget.destino!.id, nuevo);
    }

    if (!mounted) return;
    setState(() => _guardando = false);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(widget.destino == null
            ? "Destino registrado"
            : "Destino actualizado"),
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.destino != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? "Editar destino" : "Registrar destino"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(
                labelText: "Nombre del destino",
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? "Ingrese el nombre" : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _comunidadCtrl,
              decoration: const InputDecoration(
                labelText: "Comunidad",
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? "Ingrese la comunidad"
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _precioCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Precio por persona",
                prefixText: "\$ ",
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return "Ingrese el precio";
                if (double.tryParse(v) == null) return "Precio invalido";
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Descripcion",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? "Ingrese la descripcion"
                  : null,
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _guardando ? null : _guardar,
              icon: _guardando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(esEdicion ? "Guardar cambios" : "Registrar"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
