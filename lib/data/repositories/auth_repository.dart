import 'package:flutter_lab/data/models/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<User> register(User user);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<void> updateProfile(User user);
  Future<void> deleteAccount(String email);
  Future<bool> isLoggedIn();
}
