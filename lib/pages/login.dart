import 'package:flutter/material.dart';
import 'package:flutter_lab/data/repositories/local_auth_repository.dart';
import 'package:flutter_lab/pages/home.dart';
import 'package:flutter_lab/pages/register.dart';
import 'package:flutter_lab/widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authRepository = LocalAuthRepository();
  bool _isLoading = false;

  Future<void> _login(String email, String password) async {
    setState(() => _isLoading = true);
    try {
      await _authRepository.login(email, password);
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomePage()),
      );
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoginForm(
          isLoading: _isLoading,
          onSubmit: _login,
          onRegisterTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const RegisterPage()),
          ),
        ),
      ),
    );
  }
}
