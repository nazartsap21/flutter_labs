import 'package:flutter/material.dart';
import 'package:flutter_lab/data/services/validator.dart';
import 'package:flutter_lab/widgets/input.dart';
import 'package:flutter_lab/widgets/password_field.dart';

class RegisterFormData {
  const RegisterFormData({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({
    required this.onSubmit,
    required this.isLoading,
    required this.onLoginTap,
    super.key,
  });

  final Future<void> Function(RegisterFormData data) onSubmit;
  final bool isLoading;
  final VoidCallback onLoginTap;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate() {
    final nameError = Validator.validateName(_nameController.text.trim());
    final emailError = Validator.validateEmail(_emailController.text.trim());
    final passwordError = Validator.validatePassword(_passwordController.text);
    final confirmError = Validator.validateConfirmPassword(
      _passwordController.text,
      _confirmPasswordController.text,
    );

    setState(() {
      _nameError = nameError;
      _emailError = emailError;
      _passwordError = passwordError;
      _confirmPasswordError = confirmError;
    });

    return nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    await widget.onSubmit(
      RegisterFormData(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 48),
          const Text(
            'Create Account',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Fill in your details to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          WeatherInput(
            label: 'Name',
            hintText: 'Enter your name',
            prefixIcon: Icons.person_outline_rounded,
            keyboardType: TextInputType.name,
            controller: _nameController,
            errorText: _nameError,
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          PasswordField(
            label: 'Confirm Password',
            hintText: 'Repeat your password',
            controller: _confirmPasswordController,
            errorText: _confirmPasswordError,
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: widget.isLoading ? null : _submit,
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Create Account'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Already have an account?'),
              TextButton(
                onPressed: widget.onLoginTap,
                child: const Text('Login'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
