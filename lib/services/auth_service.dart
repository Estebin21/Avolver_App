import 'package:dio/dio.dart';
import '../core/storage.dart';
import 'api_client.dart';

class AuthService {
  static Future<void> login({
    required String correo,
    required String password,
  }) async {
    try {
      final res = await ApiClient.dio.post(
        '/auth/login',
        data: {'correo': correo, 'password': password},
      );

      // ⚠️ No me pasaste la respuesta del login.
      // Soporto los formatos más comunes:
      final data = res.data;
      final token =
          (data is Map && data['token'] != null) ? data['token'] :
          (data is Map && data['access_token'] != null) ? data['access_token'] :
          (data is Map && data['jwt'] != null) ? data['jwt'] :
          null;

      // Si tu backend NO devuelve token (solo "ok"), igual dejamos sesión mock.
      await AppStorage.saveToken(token?.toString() ?? 'logged_in');
    } on DioException catch (e) {
      final msg = e.response?.data?.toString() ?? 'Login falló';
      throw Exception(msg);
    }
  }

  static Future<void> logout() async => AppStorage.clearToken();
}
