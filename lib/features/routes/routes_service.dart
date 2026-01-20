import 'dart:convert';
import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/gateway_envelope.dart';
import '../../core/constants.dart';
import 'routes_models.dart';

class RoutesService {
  final ApiClient _api = ApiClient();

  Future<List<RouteSummary>> listRoutes() async {
    // endpoint_id 06, request ""
    final body = GatewayEnvelope.buildRaw(endpointId: '06', requestRaw: '');

    try {
      final res = await _api.dio.post(AppConstants.gatewayUrl, data: body);
      final decoded = _decodeGatewayResponse(res.data);

      if (decoded is List) {
        return decoded.whereType<Map>().map((m) => RouteSummary.fromJson(m.cast<String, dynamic>())).toList();
      }
      throw Exception('Respuesta inesperada al listar rutas.');
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  Future<RouteDetail> getRouteById(String routeId) async {
    // endpoint_id 05, request "<id>"
    final body = GatewayEnvelope.buildRaw(endpointId: '05', requestRaw: routeId);

    try {
      final res = await _api.dio.post(AppConstants.gatewayUrl, data: body);
      final decoded = _decodeGatewayResponse(res.data);

      // Puede venir Map (ruta) o List con 1 elemento
      if (decoded is Map) {
        return RouteDetail.fromJson(decoded.cast<String, dynamic>());
      }
      if (decoded is List && decoded.isNotEmpty && decoded.first is Map) {
        return RouteDetail.fromJson((decoded.first as Map).cast<String, dynamic>());
      }

      throw Exception('Respuesta inesperada al obtener ruta.');
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  /// Tu gateway devuelve muchas veces: { "response": "<JSON STRING>" }
  /// donde ese string puede venir doble-escapado.
  dynamic _decodeGatewayResponse(dynamic data) {
    // Caso típico: Map con key "response"
    if (data is Map && data['response'] is String) {
      return _parsePossiblyDoubleEncodedJson(data['response'] as String);
    }

    // A veces puede venir directo string JSON
    if (data is String) {
      return _parsePossiblyDoubleEncodedJson(data);
    }

    // O ya viene como estructura
    return data;
  }

  dynamic _parsePossiblyDoubleEncodedJson(String raw) {
    // 1er decode
    dynamic first = _tryJsonDecode(raw);

    // si el primer decode devuelve un String (doble encoded), decode otra vez
    if (first is String) {
      final second = _tryJsonDecode(first);
      if (second != null) return second;
    }

    return first ?? raw;
  }

  dynamic _tryJsonDecode(String s) {
    try {
      return jsonDecode(s);
    } catch (_) {
      return null;
    }
  }

  String _friendlyError(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['message'] ?? data['detail'] ?? data['error'];
      if (msg != null) return msg.toString();
    }
    return 'Error de conexión o servidor.';
  }
}
