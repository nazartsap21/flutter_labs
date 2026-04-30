import 'package:dio/dio.dart';
import 'package:flutter_lab/data/services/local_storage_service.dart';

class ApiService {
  static const _baseUrl = 'http://192.168.1.104:5000';
  static const _tokenKey = 'auth_token';

  static final _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static Future<void> init() async {
    final token = await LocalStorageService.getString(_tokenKey);
    if (token != null) _applyToken(token);
  }

  static void _applyToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearToken() {
    _dio.options.headers.remove('Authorization');
  }

  static Future<void> saveToken(String token) async {
    await LocalStorageService.setString(_tokenKey, token);
    _applyToken(token);
  }

  static Future<void> removeToken() async {
    await LocalStorageService.remove(_tokenKey);
    clearToken();
  }

  static Future<Response<dynamic>> get(String path) => _dio.get(path);

  static Future<Response<dynamic>> post(
    String path, {
    dynamic data,
  }) =>
      _dio.post(path, data: data);

  static Future<Response<dynamic>> put(
    String path, {
    dynamic data,
  }) =>
      _dio.put(path, data: data);

  static Future<Response<dynamic>> delete(String path) =>
      _dio.delete(path);
}
