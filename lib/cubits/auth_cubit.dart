import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab/data/models/user.dart';
import 'package:flutter_lab/data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthInitial());

  final AuthRepository _repository;

  Future<void> checkAuth() async {
    try {
      final loggedIn = await _repository.isLoggedIn();
      if (!loggedIn) {
        emit(const AuthUnauthenticated());
        return;
      }
      final user = await _repository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> loadUser() async {
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> login(String email, String password) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(email, password);
      emit(AuthAuthenticated(user));
    } on Exception catch (e) {
      emit(AuthError(_clean(e)));
    }
  }

  Future<void> register(User user) async {
    emit(const AuthLoading());
    try {
      final registered = await _repository.register(user);
      emit(AuthAuthenticated(registered));
    } on Exception catch (e) {
      emit(AuthError(_clean(e)));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> updateProfile(User user) async {
    emit(const AuthLoading());
    try {
      await _repository.updateProfile(user);
      emit(AuthAuthenticated(user.copyWith(password: '')));
    } on Exception catch (e) {
      emit(AuthError(_clean(e)));
    }
  }

  Future<void> deleteAccount(String email) async {
    emit(const AuthLoading());
    try {
      await _repository.deleteAccount(email);
      emit(const AuthUnauthenticated());
    } on Exception catch (e) {
      emit(AuthError(_clean(e)));
    }
  }

  String _clean(Exception e) =>
      e.toString().replaceFirst('Exception: ', '');
}
