import 'package:flutter/material.dart';
import 'package:flutter_lab/widgets/input.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.label,
    required this.controller,
    super.key,
    this.hintText,
    this.errorText,
  });

  final String label;
  final String? hintText;
  final TextEditingController controller;
  final String? errorText;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return WeatherInput(
      label: widget.label,
      hintText: widget.hintText,
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: !_visible,
      controller: widget.controller,
      errorText: widget.errorText,
      suffixIcon: IconButton(
        icon: Icon(
          _visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          size: 20,
        ),
        onPressed: () => setState(() => _visible = !_visible),
      ),
    );
  }
}
