import 'package:flutter/material.dart';
import 'package:flutter_lab/data/models/meteostation.dart';
import 'package:flutter_lab/data/models/user.dart';
import 'package:flutter_lab/data/repositories/local_auth_repository.dart';
import 'package:flutter_lab/data/repositories/local_meteostation_repository.dart';
import 'package:flutter_lab/pages/profile.dart';
import 'package:flutter_lab/widgets/confirm_dialog.dart';
import 'package:flutter_lab/widgets/meteostation.dart';
import 'package:flutter_lab/widgets/metric.dart';
import 'package:flutter_lab/widgets/station_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authRepository = LocalAuthRepository();
  final _stationRepository = LocalMeteostationRepository();

  User? _user;
  List<Meteostation> _stations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final user = await _authRepository.getCurrentUser();
    if (!mounted) return;
    if (user == null) {
      setState(() => _isLoading = false);
      return;
    }
    final stations = await _stationRepository.getStations(user.id);
    if (!mounted) return;
    setState(() {
      _user = user;
      _stations = stations;
      _isLoading = false;
    });
  }

  void _openStationDialog({Meteostation? existing}) {
    showDialog<void>(
      context: context,
      builder: (_) => StationDialog(
        userId: _user!.id,
        existing: existing,
        onSaved: _loadData,
      ),
    );
  }

  Future<void> _deleteStation(Meteostation station) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete Station',
      content: 'Remove "${station.name}"?',
      confirmLabel: 'Delete',
      isDestructive: true,
    );
    if (!confirmed) return;
    await _stationRepository.deleteStation(station.id, station.userId);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Meteostations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            tooltip: 'Profile',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const ProfilePage()),
              );
              await _loadData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sensors_off_outlined,
                          size: 56, color: Colors.grey),
                      const SizedBox(height: 12),
                      const Text('No stations yet',
                          style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _user != null ? _openStationDialog : null,
                        icon: const Icon(Icons.add),
                        label: const Text('Add Station'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 12),
                  itemCount: _stations.length,
                  itemBuilder: (context, index) {
                    final station = _stations[index];
                    return MeteostationCard(
                      name: station.name,
                      location: station.location,
                      metrics: const [
                        MetricTile(label: 'Temp', value: '—'),
                        MetricTile(label: 'Hum', value: '—'),
                        MetricTile(label: 'Wind', value: '—'),
                      ],
                      onEdit: () => _openStationDialog(existing: station),
                      onDelete: () => _deleteStation(station),
                    );
                  },
                ),
      floatingActionButton: _user != null && _stations.isNotEmpty
          ? FloatingActionButton(
              onPressed: _openStationDialog,
              tooltip: 'Add Station',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
