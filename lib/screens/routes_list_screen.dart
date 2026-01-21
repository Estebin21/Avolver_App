import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../features/routes/routes_models.dart';
import '../features/routes/routes_service.dart';
import '../core/api/error_mapper.dart';
import 'route_stops_screen.dart';

class RoutesListScreen extends StatefulWidget {
  const RoutesListScreen({super.key});

  @override
  State<RoutesListScreen> createState() => _RoutesListScreenState();
}

class _RoutesListScreenState extends State<RoutesListScreen> {
  final _service = RoutesService();

  bool _loading = true;
  String? _error;
  List<RouteSummary> _routes = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final routes = await _service.listRoutes();
      if (!mounted) return;
      setState(() {
        _routes = routes;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = ErrorMapper.toUserMessage(e);
        _loading = false;
      });
    }
  }

  void _openStops(RouteSummary route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RouteStopsScreen(routeId: route.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Rutas',
      subtitle: 'Selecciona una ruta para ver sus paradas',
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _load,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  itemCount: _routes.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final r = _routes[i];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        title: Text(
                          r.nombre,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          r.frecuencia != null
                              ? 'Frecuencia: ${r.frecuencia} min'
                              : 'Frecuencia: -',
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _openStops(r),
                      ),
                    );
                  },
                ),
    );
  }
}
