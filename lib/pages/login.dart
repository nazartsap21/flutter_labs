import 'package:flutter/material.dart';
import 'package:flutter_lab/data/repositories/api_auth_repository.dart';
import 'package:flutter_lab/pages/home.dart';
import 'package:flutter_lab/pages/register.dart';
import 'package:flutter_lab/providers/connectivity_provider.dart';
import 'package:flutter_lab/widgets/login_form.dart';
import 'package:flutter_lab/widgets/offline_banner.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authRepository = ApiAuthRepository();
  bool _isLoading = false;

  Future<void> _login(String email, String password) async {
    final connectivity = context.read<ConnectivityProvider>();
    if (!connectivity.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Please check your network.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authRepository.login(email, password);
      if (!mounted) return;
      await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomePage()),
        (_) => false,
      );
    } on Exception catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OfflineBanner(),
            Expanded(
              child: LoginForm(
                isLoading: _isLoading,
                onSubmit: _login,
                onRegisterTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const RegisterPage(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
