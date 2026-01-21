import 'dart:convert';
import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/api/gateway_envelope.dart';
import '../../core/constants.dart';
import '../../core/storage/token_storage.dart';

class AuthService {
  final ApiClient _api = ApiClient();

  // =========================
  // REGISTRO -> endpoint_id "03"
  // =========================
  Future<void> register({
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
  }) async {
    final requestObj = {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'password': password,
    };

    final body = GatewayEnvelope.buildJson(
      endpointId: '03',
      requestObj: requestObj,
    );

    try {
      await _api.dio.post(AppConstants.gatewayUrl, data: body);
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  // =========================
  // LOGIN -> endpoint_id "04"
  // =========================
  Future<void> login({
    required String correo,
    required String password,
  }) async {
    final requestObj = {
      'correo': correo,
      'password': password,
    };

    final body = GatewayEnvelope.buildJson(
      endpointId: '04',
      requestObj: requestObj,
    );

    try {
      final res = await _api.dio.post(
        AppConstants.gatewayUrl,
        data: body,
      );

      final token = _extractToken(res.data);

      if (token == null || token.isEmpty) {
        throw Exception('Login exitoso, pero no se recibió token.');
      }

      await TokenStorage.saveToken(token);
    } on DioException catch (e) {
      throw Exception(_friendlyError(e));
    }
  }

  // =========================
  // LOGOUT (NUEVO)
  // =========================
  Future<void> logout() async {
    await TokenStorage.clear();
  }

  // =========================
  // TOKEN PARSER
  // =========================
  String? _extractToken(dynamic data) {
    if (data is Map) {
      final t = data['access_token'] ?? data['token'];
      if (t != null) return t.toString();

      final resp = data['response'];
      if (resp is String) {
        try {
          final parsed = jsonDecode(resp);
          if (parsed is Map) {
            final t2 = parsed['access_token'] ?? parsed['token'];
            if (t2 != null) return t2.toString();
          }
        } catch (_) {}
      }
    }

    if (data is String) {
      try {
        final parsed = jsonDecode(data);
        if (parsed is Map) {
          final t3 = parsed['access_token'] ?? parsed['token'];
          if (t3 != null) return t3.toString();
        }
      } catch (_) {}
    }

    return null;
  }

  // =========================
  // ERROR FRIENDLY (SE MANTIENE)
  // =========================
  String _friendlyError(DioException e) {
    final data = e.response?.data;
    if (data is Map) {
      final msg = data['message'] ?? data['detail'] ?? data['error'];
      if (msg != null) return msg.toString();
    }
    if (e.response?.statusCode == 401) return 'Credenciales incorrectas.';
    return 'Error de conexión o servidor.';
  }
}
