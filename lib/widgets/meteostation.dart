import 'package:flutter/material.dart';
import 'package:flutter_lab/widgets/metric.dart';

class MeteostationCard extends StatelessWidget {
  const MeteostationCard({
    required this.name,
    required this.location,
    required this.metrics,
    super.key,
  });

  final String name;
  final String location;
  final List<MetricTile> metrics;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              location,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: metrics,
            ),
          ],
        ),
      ),
    );
  }
}
