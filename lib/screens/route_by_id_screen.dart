import 'package:flutter/material.dart';
import '../mock/mock_data.dart';

class RouteByIdScreen extends StatefulWidget {
  const RouteByIdScreen({super.key});

  @override
  State<RouteByIdScreen> createState() => _RouteByIdScreenState();
}

class _RouteByIdScreenState extends State<RouteByIdScreen> {
  final _idCtrl = TextEditingController();
  MockRoute? _found;

  @override
  void dispose() {
    _idCtrl.dispose();
    super.dispose();
  }

  void _searchFake() {
    final id = int.tryParse(_idCtrl.text.trim());
    setState(() {
      _found = (id == null) ? null : mockRoutes.where((r) => r.id == id).cast<MockRoute?>().firstWhere(
            (x) => x != null,
            orElse: () => null,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Obtener ruta por ID')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _idCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Ingresa el ID de la ruta',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _searchFake,
                child: const Text('Buscar'),
              ),
            ),
            const SizedBox(height: 20),
            if (_found == null && _idCtrl.text.isNotEmpty)
              const Text('No se encontró esa ruta.'),
            if (_found != null)
              Card(
                child: ListTile(
                  title: Text('${_found!.id} - ${_found!.nombre}'),
                  subtitle: Text(
                    'Origen: ${_found!.origen}\nDestino: ${_found!.destino}\nHorario: ${_found!.horario}',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
