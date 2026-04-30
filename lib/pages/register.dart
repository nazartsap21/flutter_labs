import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab/cubits/auth_cubit.dart';
import 'package:flutter_lab/cubits/station_cubit.dart';
import 'package:flutter_lab/data/models/register_form_data.dart';
import 'package:flutter_lab/data/models/user.dart';
import 'package:flutter_lab/pages/home.dart';
import 'package:flutter_lab/pages/login.dart';
import 'package:flutter_lab/widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  Future<void> _onRegister(
    BuildContext context,
    RegisterFormData data,
  ) async {
    final user = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: data.name,
      email: data.email,
      password: data.password,
    );
    await context.read<AuthCubit>().register(user);
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
          child: RegisterForm(
            isLoading: state is AuthLoading,
            onSubmit: (data) => _onRegister(context, data),
            onLoginTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const LoginPage(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
