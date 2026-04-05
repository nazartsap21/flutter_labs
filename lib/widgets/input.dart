import 'package:flutter/material.dart';

class WeatherInput extends StatelessWidget {
  const WeatherInput({
    required this.label,
    super.key,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSubmitted,
    this.keyboardType,
  });

  final String label;
  final String? hintText;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 16),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20)
            : null,
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
