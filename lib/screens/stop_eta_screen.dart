import 'dart:async';
import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';
import '../features/routes/routes_models.dart';
import '../features/routes/routes_service.dart';
import '../core/api/error_mapper.dart';

class StopEtaScreen extends StatefulWidget {
  final String routeId;
  final StopInfo stop;

  const StopEtaScreen({
    super.key,
    required this.routeId,
    required this.stop,
  });

  @override
  State<StopEtaScreen> createState() => _StopEtaScreenState();
}

class _StopEtaScreenState extends State<StopEtaScreen> with WidgetsBindingObserver {
  final _service = RoutesService();

  Timer? _timer;
  bool _loading = true;
  String? _error;

  int? _eta;
  late final String _stopKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _stopKey = _buildStopKey(widget.stop);
    _eta = _parseEta(widget.stop.tiempo);

    _refreshEta(showSpinner: true);
    _startPolling();
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pausa el polling cuando la app no está activa
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _timer?.cancel();
      _timer = null;
      return;
    }

    // Reanuda el polling al volver
    if (state == AppLifecycleState.resumed) {
      _startPolling();
      _refreshEta(showSpinner: false);
    }
  }

  void _startPolling() {
    _timer?.cancel();

    // ✅ Cada 3 minutos
    _timer = Timer.periodic(const Duration(minutes: 3), (_) {
      _refreshEta(showSpinner: false);
    });
  }

  String _buildStopKey(StopInfo s) {
    return '${s.nombre}||${s.callePrincipal}||${s.calleSecundaria}'.toLowerCase().trim();
  }

  int? _parseEta(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is double) return v.round();
    if (v is String) return int.tryParse(v);
    return null;
  }

  Future<void> _refreshEta({required bool showSpinner}) async {
    if (showSpinner) {
      setState(() {
        _loading = true;
        _error = null;
      });
    } else {
      if (mounted) setState(() => _error = null);
    }

    try {
      final detail = await _service.getRouteById(widget.routeId);

      final found = detail.paradas.firstWhere(
        (p) => _buildStopKey(p) == _stopKey,
        orElse: () => widget.stop,
      );

      final newEta = _parseEta(found.tiempo);

      if (!mounted) return;
      setState(() {
        _eta = newEta;
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Tiempo estimado',
      subtitle: widget.stop.nombre,
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
                        onPressed: () => _refreshEta(showSpinner: true),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.stop.nombre,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text('Calle principal: ${widget.stop.callePrincipal}'),
                        Text('Calle secundaria: ${widget.stop.calleSecundaria}'),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded),
                            const SizedBox(width: 8),
                            Text(
                              _eta == null ? 'Tiempo estimado: -' : 'Tiempo estimado: $_eta min',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
