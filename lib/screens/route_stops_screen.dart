import 'package:flutter/material.dart';
import '../widgets/app_scaffold.dart';
import '../features/routes/routes_models.dart';
import '../features/routes/routes_service.dart';
import '../core/api/error_mapper.dart';
import 'stop_eta_screen.dart';

class RouteStopsScreen extends StatefulWidget {
  final String routeId;

  const RouteStopsScreen({super.key, required this.routeId});

  @override
  State<RouteStopsScreen> createState() => _RouteStopsScreenState();
}

class _RouteStopsScreenState extends State<RouteStopsScreen> {
  final _service = RoutesService();

  bool _loading = true;
  String? _error;
  List<StopInfo> _stops = [];

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
      final detail = await _service.getRouteById(widget.routeId);
      if (!mounted) return;
      setState(() {
        _stops = detail.paradas;
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

  void _openStop(StopInfo stop) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StopEtaScreen(
          routeId: widget.routeId,
          stop: stop,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Paradas',
      subtitle: 'Ruta: ${widget.routeId}',
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
                  itemCount: _stops.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, i) {
                    final s = _stops[i];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: ListTile(
                        title: Text(
                          s.nombre,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        subtitle: Text(
                          'Calle principal: ${s.callePrincipal}\n'
                          'Calle secundaria: ${s.calleSecundaria}',
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _openStop(s),
                      ),
                    );
                  },
                ),
    );
  }
}
