import 'dart:convert';
import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/gateway_envelope.dart';
import '../../core/constants.dart';
import 'reports_models.dart';

class ReportsService {
  final ApiClient _api = ApiClient();

  Future<List<ReportItem>> listReports() async {
    final body = GatewayEnvelope.buildRaw(endpointId: '01', requestRaw: '');

    try {
      final res = await _api.dio.post(AppConstants.gatewayUrl, data: body);
      final decoded = _decodeGatewayResponse(res.data);

      if (decoded is List) {
        return decoded.whereType<Map>().map((m) => ReportItem.fromJson(m.cast<String, dynamic>())).toList();
      }
      throw Exception('Respuesta inesperada al obtener reportes.');
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  Future<void> createReport({
    required String rutaId,
    required String motivo,
    required int retrasoEstimado,
  }) async {
    final requestObj = {
      'ruta_id': rutaId,
      'motivo': motivo,
      'retrasoEstimado': retrasoEstimado,
    };

    final body = GatewayEnvelope.buildJson(endpointId: '02', requestObj: requestObj);

    try {
      await _api.dio.post(AppConstants.gatewayUrl, data: body);
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  dynamic _decodeGatewayResponse(dynamic data) {
    if (data is Map && data['response'] is String) {
      return _parsePossiblyDoubleEncodedJson(data['response'] as String);
    }
    if (data is String) {
      return _parsePossiblyDoubleEncodedJson(data);
    }
    return data;
  }

  dynamic _parsePossiblyDoubleEncodedJson(String raw) {
    dynamic first = _tryJsonDecode(raw);
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
