import 'package:flutter/material.dart';
import 'package:flutter_lab/data/services/validator.dart';
import 'package:flutter_lab/widgets/input.dart';
import 'package:flutter_lab/widgets/password_field.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    required this.onSubmit,
    required this.isLoading,
    required this.onRegisterTap,
    super.key,
  });

  final Future<void> Function(String email, String password) onSubmit;
  final bool isLoading;
  final VoidCallback onRegisterTap;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final emailError = Validator.validateEmail(_emailController.text.trim());
    final passwordError = Validator.validatePassword(_passwordController.text);
    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });
    if (emailError != null || passwordError != null) return;
    await widget.onSubmit(
      _emailController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 60),
          const Icon(Icons.wb_sunny_outlined, size: 56),
          const SizedBox(height: 12),
          const Text(
            'Weather Station',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sign in to continue',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 36),
          WeatherInput(
            label: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            errorText: _emailError,
          ),
          const SizedBox(height: 16),
          PasswordField(
            label: 'Password',
            hintText: 'Enter your password',
            controller: _passwordController,
            errorText: _passwordError,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submit,
              child: widget.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Login'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: widget.onRegisterTap,
                child: const Text('Register'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
