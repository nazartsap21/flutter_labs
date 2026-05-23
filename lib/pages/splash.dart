import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab/cubits/auth_cubit.dart';
import 'package:flutter_lab/cubits/station_cubit.dart';
import 'package:flutter_lab/pages/home.dart';
import 'package:flutter_lab/pages/login.dart';
import 'package:flutter_lab/providers/connectivity_provider.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final connectivity = context.read<ConnectivityProvider>();
          if (!connectivity.isConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No internet connection. '
                  'Some features may be unavailable.',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 5),
              ),
            );
          }
          context.read<StationCubit>().loadStations(state.user.id);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => const HomePage()),
          );
        } else if (state is AuthUnauthenticated || state is AuthError) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => const LoginPage()),
          );
        }
      },
      child: const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
