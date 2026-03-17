import 'package:flutter/material.dart';
import 'package:flutter_lab/pages/profile.dart';
import 'package:flutter_lab/widgets/meteostation.dart';
import 'package:flutter_lab/widgets/metric.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Meteostations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ProfilePage()
                )
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        children: const [
          MeteostationCard(
            name: 'First station',
            location: 'Lviv, Ukraine',
            metrics: [
              MetricTile(label: 'Temp', value: '23°C'),
              MetricTile(label: 'Hum', value: '55%'),
              MetricTile(label: 'Wind', value: '8 km/h'),
            ],
          ),
        ],
      ),
    );
  }
}
