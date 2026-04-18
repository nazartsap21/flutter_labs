import 'package:flutter/material.dart';

class WeatherInput extends StatelessWidget {
  const WeatherInput({
    required this.label,
    super.key,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.keyboardType,
    this.errorText,
    this.readOnly = false,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      obscureText: obscureText,
      readOnly: readOnly,
      style: const TextStyle(fontSize: 16),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: errorText,
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        suffixIcon: suffixIcon != null
            ? IconTheme(
                data: const IconThemeData(size: 20),
                child: suffixIcon!,
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
