import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab/cubits/auth_cubit.dart';
import 'package:flutter_lab/cubits/station_cubit.dart';
import 'package:flutter_lab/data/models/user.dart';
import 'package:flutter_lab/pages/login.dart';
import 'package:flutter_lab/providers/connectivity_provider.dart';
import 'package:flutter_lab/widgets/confirm_dialog.dart';
import 'package:flutter_lab/widgets/edit_profile_dialog.dart';
import 'package:flutter_lab/widgets/offline_banner.dart';
import 'package:flutter_lab/widgets/profile_actions.dart';
import 'package:flutter_lab/widgets/profile_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _openEditDialog(BuildContext context, User user) {
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<AuthCubit>(),
        child: EditProfileDialog(user: user),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Log Out',
      content: 'Are you sure you want to log out?',
      confirmLabel: 'Log Out',
    );
    if (!context.mounted || !confirmed) return;
    await context.read<AuthCubit>().logout();
  }

  Future<void> _confirmDeleteAccount(
    BuildContext context,
    User user,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Account',
      content: 'This will permanently delete your account and all your '
          'stations. This action cannot be undone.',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!context.mounted || !confirmed) return;
    await context.read<StationCubit>().deleteAllForUser(user.id);
    if (!context.mounted) return;
    await context.read<AuthCubit>().deleteAccount(user.email);
  }

  @override
  Widget build(BuildContext context) {
    final online = context.watch<ConnectivityProvider>().isConnected;
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (_, curr) =>
          curr is AuthUnauthenticated || curr is AuthError,
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const LoginPage()),
            (_) => false,
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.read<AuthCubit>().loadUser();
        }
      },
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final user = state.user;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              if (online)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit',
                  onPressed: () => _openEditDialog(context, user),
                ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const OfflineBanner(),
              ProfileInfoCard(name: user.name, email: user.email),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ProfileActions(
                  online: online,
                  onEdit: () => _openEditDialog(context, user),
                  onLogout: () => _confirmLogout(context),
                  onDelete: () => _confirmDeleteAccount(context, user),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
