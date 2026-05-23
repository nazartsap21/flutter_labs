import 'package:flutter/material.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({
    required this.online,
    required this.onEdit,
    required this.onLogout,
    required this.onDelete,
    super.key,
  });

  final bool online;
  final VoidCallback onEdit;
  final VoidCallback onLogout;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (online)
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Profile'),
          ),
        if (online) const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onLogout,
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
        ),
        if (online) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: onDelete,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            icon: const Icon(Icons.delete_forever_outlined),
            label: const Text('Delete Account'),
          ),
        ],
      ],
    );
  }
}
