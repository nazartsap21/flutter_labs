import 'dart:convert';

import 'package:flutter_lab/data/models/user.dart';
import 'package:flutter_lab/data/repositories/auth_repository.dart';
import 'package:flutter_lab/data/services/local_storage_service.dart';

class LocalAuthRepository implements AuthRepository {
  static const String _sessionKey = 'session_email';

  static String _userKey(String email) => 'user_$email';

  @override
  Future<User> login(String email, String password) async {
    final raw = await LocalStorageService.getString(_userKey(email));
    if (raw == null) throw Exception('User not found');

    final user = User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    if (user.password != password) throw Exception('Incorrect password');

    await LocalStorageService.setString(_sessionKey, email);
    return user;
  }

  @override
  Future<User> register(User user) async {
    final existing =
        await LocalStorageService.getString(_userKey(user.email));
    if (existing != null) throw Exception('Email already registered');

    await LocalStorageService.setString(
      _userKey(user.email),
      jsonEncode(user.toJson()),
    );
    await LocalStorageService.setString(_sessionKey, user.email);
    return user;
  }

  @override
  Future<void> logout() async {
    await LocalStorageService.remove(_sessionKey);
  }

  @override
  Future<User?> getCurrentUser() async {
    final email = await LocalStorageService.getString(_sessionKey);
    if (email == null) return null;
    final raw = await LocalStorageService.getString(_userKey(email));
    if (raw == null) return null;
    return User.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  @override
  Future<void> updateProfile(User user) async {
    await LocalStorageService.setString(
      _userKey(user.email),
      jsonEncode(user.toJson()),
    );
  }

  @override
  Future<void> deleteAccount(String email) async {
    await LocalStorageService.remove(_userKey(email));
    await LocalStorageService.remove(_sessionKey);
  }

  @override
  Future<bool> isLoggedIn() async {
    final email = await LocalStorageService.getString(_sessionKey);
    return email != null;
  }
}
