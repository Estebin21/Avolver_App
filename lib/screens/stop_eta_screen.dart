import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../features/routes/routes_models.dart';

class StopEtaScreen extends StatelessWidget {
  final String routeId;
  final StopInfo stop;

  const StopEtaScreen({super.key, required this.routeId, required this.stop});

  @override
  Widget build(BuildContext context) {
    debugPrint('ETA SCREEN => ${stop.nombre} | tiempo=${stop.tiempo}');

    final tiempoTxt = (stop.tiempo == null) ? '-' : stop.tiempo.toString();

    return AppScaffold(
      title: 'Detalle de parada',
      subtitle: 'Ruta: $routeId',
      child: ListView(
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stop.nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 10),
                  Text('Calle principal: ${stop.callePrincipal}'),
                  const SizedBox(height: 6),
                  Text('Calle secundaria: ${stop.calleSecundaria}'),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text('Tiempo estimado a esta parada', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 8),
                  Text('$tiempoTxt min', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
