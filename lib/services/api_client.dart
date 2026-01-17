import 'package:dio/dio.dart';
import '../core/storage.dart';

class ApiClient {
  static const String baseUrl = 'http://10.0.2.2:3000';

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );
}

