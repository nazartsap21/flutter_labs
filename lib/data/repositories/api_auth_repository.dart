import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_lab/data/models/user.dart';
import 'package:flutter_lab/data/repositories/auth_repository.dart';
import 'package:flutter_lab/data/services/api_service.dart';
import 'package:flutter_lab/data/services/local_storage_service.dart';

class ApiAuthRepository implements AuthRepository {
  static const _cachedUserKey = 'cached_user';
  static const _tokenKey = 'auth_token';

  Future<void> _cacheUser(User user) async {
    await LocalStorageService.setString(
      _cachedUserKey,
      jsonEncode(user.toJson()),
    );
  }

  Future<User?> _getCached() async {
    final raw = await LocalStorageService.getString(_cachedUserKey);
    if (raw == null) return null;
    return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  String _msg(Object e) {
    if (e is DioException) {
      final d = e.response?.data;
      if (d is Map) return d['error'] as String? ?? 'Network error';
      return 'Network error';
    }
    return e.toString().replaceFirst('Exception: ', '');
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final res = await ApiService.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final token = res.data['token'] as String;
      final user = User.fromJson(
        res.data['user'] as Map<String, dynamic>,
      );
      await ApiService.saveToken(token);
      await _cacheUser(user);
      return user;
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  @override
  Future<User> register(User user) async {
    try {
      final res = await ApiService.post(
        '/auth/register',
        data: {
          'id': user.id,
          'name': user.name,
          'email': user.email,
          'password': user.password,
        },
      );
      final token = res.data['token'] as String;
      final created = User.fromJson(
        res.data['user'] as Map<String, dynamic>,
      );
      await ApiService.saveToken(token);
      await _cacheUser(created);
      return created;
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  @override
  Future<void> logout() async {
    await ApiService.removeToken();
    await LocalStorageService.remove(_cachedUserKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final res = await ApiService.get('/auth/me');
      final user = User.fromJson(res.data as Map<String, dynamic>);
      await _cacheUser(user);
      return user;
    } catch (_) {
      return _getCached();
    }
  }

  @override
  Future<void> updateProfile(User user) async {
    try {
      final data = <String, dynamic>{'name': user.name};
      if (user.password.isNotEmpty) data['password'] = user.password;
      await ApiService.put('/auth/me', data: data);
      await _cacheUser(user.copyWith(password: ''));
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  @override
  Future<void> deleteAccount(String email) async {
    try {
      await ApiService.delete('/auth/me');
      await ApiService.removeToken();
      await LocalStorageService.remove(_cachedUserKey);
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    await ApiService.init();
    final token = await LocalStorageService.getString(_tokenKey);
    return token != null;
  }
}
