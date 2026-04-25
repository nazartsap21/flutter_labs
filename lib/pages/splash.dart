import 'package:flutter/material.dart';
import 'package:flutter_lab/data/repositories/api_auth_repository.dart';
import 'package:flutter_lab/pages/home.dart';
import 'package:flutter_lab/pages/login.dart';
import 'package:flutter_lab/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    try {
      final repo = ApiAuthRepository();
      final loggedIn = await repo.isLoggedIn();
      if (!mounted) return;

      if (loggedIn) {
        final connectivity = context.read<ConnectivityProvider>();
        if (!connectivity.isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'No internet connection. Some features may be unavailable.',
              ),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 5),
            ),
          );
        }
        if (!mounted) return;
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const HomePage()),
        );
      } else {
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const LoginPage()),
        );
      }
    } catch (_) {
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
