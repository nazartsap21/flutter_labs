import 'package:flutter/material.dart';
import 'package:flutter_lab/data/models/user.dart';
import 'package:flutter_lab/data/repositories/local_auth_repository.dart';
import 'package:flutter_lab/pages/home.dart';
import 'package:flutter_lab/pages/login.dart';
import 'package:flutter_lab/widgets/register_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _authRepository = LocalAuthRepository();
  bool _isLoading = false;

  Future<void> _register(RegisterFormData data) async {
    setState(() => _isLoading = true);
    try {
      final user = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: data.name,
        email: data.email,
        password: data.password,
      );
      await _authRepository.register(user);

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
        child: RegisterForm(
          isLoading: _isLoading,
          onSubmit: _register,
          onLoginTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const LoginPage()),
          ),
        ),
      ),
    );
  }
}
