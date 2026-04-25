import 'package:flutter/material.dart';
import 'package:flutter_lab/data/models/meteostation.dart';
import 'package:flutter_lab/data/models/user.dart';
import 'package:flutter_lab/data/repositories/api_auth_repository.dart';
import 'package:flutter_lab/data/repositories/api_meteostation_repository.dart';
import 'package:flutter_lab/pages/profile.dart';
import 'package:flutter_lab/providers/connectivity_provider.dart';
import 'package:flutter_lab/providers/mqtt_provider.dart';
import 'package:flutter_lab/widgets/confirm_dialog.dart';
import 'package:flutter_lab/widgets/offline_banner.dart';
import 'package:flutter_lab/widgets/station_dialog.dart';
import 'package:flutter_lab/widgets/station_list.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authRepo = ApiAuthRepository();
  final _stationRepo = ApiMeteostationRepository();
  Future<List<Meteostation>>? _stationsFuture;
  User? _user;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final user = await _authRepo.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      if (user != null) {
        _stationsFuture = _stationRepo.getStations(user.id);
      }
    });
  }

  void _refresh() {
    final user = _user;
    if (user == null) return;
    final future = _stationRepo.getStations(user.id);
    setState(() { _stationsFuture = future; });
  }

  void _openDialog({Meteostation? existing}) {
    final user = _user;
    if (user == null) return;
    showDialog<void>(
      context: context,
      builder: (_) => StationDialog(
        userId: user.id,
        existing: existing,
        onSaved: _refresh,
      ),
    );
  }

  void _openAddDialog() => _openDialog();

  Future<void> _delete(Meteostation s) async {
    final ok = await showConfirmDialog(
      context,
      title: 'Delete Station',
      content: 'Remove "${s.name}"?',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!ok) return;
    await _stationRepo.deleteStation(s.id, s.userId);
    _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final online = context.watch<ConnectivityProvider>().isConnected;
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
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ProfilePage(),
                ),
              );
              _refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: FutureBuilder<List<Meteostation>>(
              future: _stationsFuture,
              builder: (_, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('${snap.error}'));
                }
                return StationListView(
                  stations: snap.data ?? [],
                  onEdit: online ? (s) => _openDialog(existing: s) : null,
                  onDelete: online ? _delete : null,
                  onAdd: online ? _openAddDialog : null,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _user != null && online
          ? FloatingActionButton(
              onPressed: _openAddDialog,
              tooltip: 'Add Station',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
