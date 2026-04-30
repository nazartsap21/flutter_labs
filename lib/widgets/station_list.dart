import 'package:flutter/material.dart';
import 'package:flutter_lab/data/models/meteostation.dart';
import 'package:flutter_lab/providers/mqtt_provider.dart';
import 'package:flutter_lab/widgets/meteostation.dart';
import 'package:flutter_lab/widgets/metric.dart';
import 'package:provider/provider.dart';

class StationListView extends StatelessWidget {
  const StationListView({
    required this.stations,
    required this.onEdit,
    required this.onDelete,
    required this.onAdd,
    super.key,
  });

  final List<Meteostation> stations;
  final void Function(Meteostation)? onEdit;
  final void Function(Meteostation)? onDelete;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    if (stations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.sensors_off_outlined,
              size: 56,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            const Text(
              'No stations yet',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add Station'),
            ),
          ],
        ),
      );
    }
    return Consumer<MqttProvider>(
      builder: (_, mqtt, _) => ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        itemCount: stations.length,
        itemBuilder: (_, i) {
          final s = stations[i];
          final edit = onEdit;
          final delete = onDelete;
          return MeteostationCard(
            name: s.name,
            location: s.location,
            metrics: [
              MetricTile(label: 'Temp', value: mqtt.temperature(s.id)),
              MetricTile(label: 'Hum', value: mqtt.humidity(s.id)),
              MetricTile(label: 'Wind', value: mqtt.wind(s.id)),
            ],
            onEdit: edit != null ? () => edit(s) : null,
            onDelete: delete != null ? () => delete(s) : null,
          );
        },
      ),
    );
  }
}
