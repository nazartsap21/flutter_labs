import 'package:flutter/material.dart';
import 'package:flutter_lab/data/models/user.dart';
import 'package:flutter_lab/data/repositories/local_auth_repository.dart';
import 'package:flutter_lab/data/repositories/local_meteostation_repository.dart';
import 'package:flutter_lab/pages/login.dart';
import 'package:flutter_lab/widgets/confirm_dialog.dart';
import 'package:flutter_lab/widgets/edit_profile_dialog.dart';
import 'package:flutter_lab/widgets/profile_info.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authRepository = LocalAuthRepository();
  final _stationRepository = LocalMeteostationRepository();

  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await _authRepository.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _isLoading = false;
    });
  }

  void _openEditDialog() {
    if (_user == null) return;
    showDialog<void>(
      context: context,
      builder: (_) => EditProfileDialog(user: _user!, onSaved: _loadUser),
    );
  }

  Future<void> _logout() async {
    await _authRepository.logout();
    if (!mounted) return;
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  Future<void> _deleteAccount() async {
    if (_user == null) return;
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Account',
      content: 'This will permanently delete your account and all your '
          'stations. This action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!confirmed) return;
    await _stationRepository.deleteAllForUser(_user!.id);
    await _authRepository.deleteAccount(_user!.email);
    if (!mounted) return;
    await Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (_user != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit',
              onPressed: _openEditDialog,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
              ? const Center(child: Text('Could not load user'))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ProfileInfoCard(name: _user!.name, email: _user!.email),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _openEditDialog,
                            icon: const Icon(Icons.edit_outlined),
                            label: const Text('Edit Profile'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            onPressed: _deleteAccount,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                            ),
                            icon: const Icon(Icons.delete_forever_outlined),
                            label: const Text('Delete Account'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
