import 'package:flutter/material.dart';
import 'package:flutter_lab/data/models/user.dart';
import 'package:flutter_lab/data/repositories/api_auth_repository.dart';
import 'package:flutter_lab/data/services/validator.dart';
import 'package:flutter_lab/widgets/input.dart';
import 'package:flutter_lab/widgets/password_field.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({
    required this.user,
    required this.onSaved,
    super.key,
  });

  final User user;
  final VoidCallback onSaved;

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _authRepository = ApiAuthRepository();
  late final TextEditingController _nameController;
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _nameError;
  String? _passwordError;
  String? _confirmError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nameError = Validator.validateName(_nameController.text.trim());
    final newPassword = _passwordController.text;
    final passwordError =
        newPassword.isNotEmpty ? Validator.validatePassword(newPassword) : null;
    final confirmError = newPassword.isNotEmpty
        ? Validator.validateConfirmPassword(
            newPassword,
            _confirmController.text,
          )
        : null;

    if (nameError != null || passwordError != null || confirmError != null) {
      setState(() {
        _nameError = nameError;
        _passwordError = passwordError;
        _confirmError = confirmError;
      });
      return;
    }

    final updated = widget.user.copyWith(
      name: _nameController.text.trim(),
      password: newPassword,
    );
    await _authRepository.updateProfile(updated);

    if (!mounted) return;
    Navigator.of(context).pop();
    widget.onSaved();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            WeatherInput(
              label: 'Name',
              prefixIcon: Icons.person_outline_rounded,
              controller: _nameController,
              errorText: _nameError,
            ),
            const SizedBox(height: 16),
            const Text(
              'Leave password fields empty to keep current password',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            PasswordField(
              label: 'New Password',
              controller: _passwordController,
              errorText: _passwordError,
            ),
            const SizedBox(height: 16),
            PasswordField(
              label: 'Confirm New Password',
              controller: _confirmController,
              errorText: _confirmError,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
