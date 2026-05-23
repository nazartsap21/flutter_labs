import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab/cubits/auth_cubit.dart';
import 'package:flutter_lab/cubits/station_cubit.dart';
import 'package:flutter_lab/data/models/meteostation.dart';
import 'package:flutter_lab/pages/profile.dart';
import 'package:flutter_lab/providers/connectivity_provider.dart';
import 'package:flutter_lab/providers/mqtt_provider.dart';
import 'package:flutter_lab/widgets/confirm_dialog.dart';
import 'package:flutter_lab/widgets/offline_banner.dart';
import 'package:flutter_lab/widgets/station_dialog.dart';
import 'package:flutter_lab/widgets/station_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _openDialog(
    BuildContext context,
    String userId, {
    Meteostation? existing,
  }) {
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<StationCubit>(),
        child: StationDialog(userId: userId, existing: existing),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final online = context.watch<ConnectivityProvider>().isConnected;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        final user =
            authState is AuthAuthenticated ? authState.user : null;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Meteostations'),
            actions: [
              Consumer<MqttProvider>(
                builder: (_, mqtt, _) {
                  final active = mqtt.connected && online;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      active ? Icons.sensors : Icons.sensors_off,
                      color: active ? Colors.green : Colors.grey,
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.person_outline),
                tooltip: 'Profile',
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const ProfilePage(),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              const OfflineBanner(),
              Expanded(child: _StationBody(online: online, userId: user?.id)),
            ],
          ),
          floatingActionButton: (user != null && online)
              ? FloatingActionButton(
                  onPressed: () => _openDialog(context, user.id),
                  tooltip: 'Add Station',
                  child: const Icon(Icons.add),
                )
              : null,
        );
      },
    );
  }
}

class _StationBody extends StatelessWidget {
  const _StationBody({required this.online, required this.userId});

  final bool online;
  final String? userId;

  void _openDialog(BuildContext context, {Meteostation? existing}) {
    final uid = userId;
    if (uid == null) return;
    showDialog<void>(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<StationCubit>(),
        child: StationDialog(userId: uid, existing: existing),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    Meteostation s,
  ) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Delete Station',
      content: 'Remove "${s.name}"?',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!context.mounted || !ok) return;
    await context.read<StationCubit>().deleteStation(s.id, s.userId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StationCubit, StationState>(
      builder: (context, state) {
        if (state is StationLoading || state is StationInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StationError) {
          return Center(child: Text(state.message));
        }
        final stations = state is StationLoaded
            ? state.stations
            : <Meteostation>[];
        return StationListView(
          stations: stations,
          onEdit: (online && userId != null)
              ? (s) => _openDialog(context, existing: s)
              : null,
          onDelete: (online && userId != null)
              ? (s) => _confirmDelete(context, s)
              : null,
          onAdd: (online && userId != null)
              ? () => _openDialog(context)
              : null,
        );
      },
    );
  }
}
