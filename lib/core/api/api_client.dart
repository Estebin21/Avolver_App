import 'dart:async';
import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  factory ApiClient() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(_RetryInterceptor(dio: dio, maxRetries: 2));
    return ApiClient._(dio);
  }
}

/// Reintenta SOLO en errores de red/timeout (resiliencia real)
class _RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;

  _RetryInterceptor({required this.dio, required this.maxRetries});

  bool _isRetryable(DioException e) {
    return e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown;
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    final retries = (requestOptions.extra['retries'] as int?) ?? 0;

    if (retries < maxRetries && _isRetryable(err)) {
      requestOptions.extra['retries'] = retries + 1;

      // Exponential backoff: 300ms, 900ms, 2700ms...
      final delayMs = 300 * (1 << retries);
      await Future.delayed(Duration(milliseconds: delayMs));

      try {
        final response = await dio.fetch(requestOptions);
        return handler.resolve(response);
      } catch (e) {
        return handler.next(err);
      }
    }

    return handler.next(err);
  }
}
