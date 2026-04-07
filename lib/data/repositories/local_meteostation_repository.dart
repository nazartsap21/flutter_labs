import 'dart:convert';

import 'package:flutter_lab/data/models/meteostation.dart';
import 'package:flutter_lab/data/repositories/meteostation_repository.dart';
import 'package:flutter_lab/data/services/local_storage_service.dart';

class LocalMeteostationRepository implements MeteostationRepository {
  static String _stationsKey(String userId) => 'stations_$userId';

  @override
  Future<List<Meteostation>> getStations(String userId) async {
    final list =
        await LocalStorageService.getStringList(_stationsKey(userId));
    return list
        .map(
          (s) =>
              Meteostation.fromJson(jsonDecode(s) as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<void> addStation(Meteostation station) async {
    final stations = await getStations(station.userId);
    stations.add(station);
    await _save(station.userId, stations);
  }

  @override
  Future<void> updateStation(Meteostation station) async {
    final stations = await getStations(station.userId);
    final index = stations.indexWhere((s) => s.id == station.id);
    if (index == -1) return;
    stations[index] = station;
    await _save(station.userId, stations);
  }

  @override
  Future<void> deleteStation(String id, String userId) async {
    final stations = await getStations(userId);
    stations.removeWhere((s) => s.id == id);
    await _save(userId, stations);
  }

  @override
  Future<void> deleteAllForUser(String userId) async {
    await LocalStorageService.remove(_stationsKey(userId));
  }

  Future<void> _save(String userId, List<Meteostation> stations) async {
    final list = stations.map((s) => jsonEncode(s.toJson())).toList();
    await LocalStorageService.setStringList(_stationsKey(userId), list);
  }
}
