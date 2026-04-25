import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab/cubits/auth_cubit.dart';
import 'package:flutter_lab/cubits/station_cubit.dart';
import 'package:flutter_lab/pages/home.dart';
import 'package:flutter_lab/pages/register.dart';
import 'package:flutter_lab/providers/connectivity_provider.dart';
import 'package:flutter_lab/widgets/login_form.dart';
import 'package:flutter_lab/widgets/offline_banner.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<void> _onLogin(
    BuildContext context,
    String email,
    String password,
  ) async {
    final connectivity = context.read<ConnectivityProvider>();
    if (!connectivity.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No internet connection. Please check your network.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await context.read<AuthCubit>().login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (_, curr) =>
          curr is AuthAuthenticated || curr is AuthError,
      listener: (context, state) {
        if (ModalRoute.of(context)?.isCurrent != true) return;
        if (state is AuthAuthenticated) {
          context.read<StationCubit>().loadStations(state.user.id);
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const HomePage()),
            (_) => false,
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) => Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const OfflineBanner(),
              Expanded(
                child: LoginForm(
                  isLoading: state is AuthLoading,
                  onSubmit: (email, pass) =>
                      _onLogin(context, email, pass),
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
      ),
    );
  }
}
