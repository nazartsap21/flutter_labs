import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_lab/data/models/meteostation.dart';
import 'package:flutter_lab/data/repositories/meteostation_repository.dart';
import 'package:flutter_lab/data/services/api_service.dart';
import 'package:flutter_lab/data/services/local_storage_service.dart';

class ApiMeteostationRepository implements MeteostationRepository {
  static String _key(String userId) => 'cached_stations_$userId';

  Future<void> _cache(String userId, List<Meteostation> stations) async {
    final list = stations.map((s) => jsonEncode(s.toJson())).toList();
    await LocalStorageService.setStringList(_key(userId), list);
  }

  Future<List<Meteostation>> _readCache(String userId) async {
    final list = await LocalStorageService.getStringList(_key(userId));
    return list
        .map(
          (s) => Meteostation.fromJson(
            jsonDecode(s) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  String _msg(Object e) {
    if (e is DioException) {
      final d = e.response?.data;
      if (d is Map) return d['error'] as String? ?? 'Network error';
      return 'Network error';
    }
    return e.toString().replaceFirst('Exception: ', '');
  }

  @override
  Future<List<Meteostation>> getStations(String userId) async {
    try {
      final res = await ApiService.get('/stations');
      final stations = (res.data as List)
          .map((s) => Meteostation.fromJson(s as Map<String, dynamic>)
              .copyWith(userId: userId))
          .toList();
      await _cache(userId, stations);
      return stations;
    } catch (_) {
      return _readCache(userId);
    }
  }

  @override
  Future<void> addStation(Meteostation station) async {
    try {
      await ApiService.post('/stations', data: {
        'id': station.id,
        'name': station.name,
        'location': station.location,
      });
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  @override
  Future<void> updateStation(Meteostation station) async {
    try {
      await ApiService.put(
        '/stations/${station.id}',
        data: {'name': station.name, 'location': station.location},
      );
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  @override
  Future<void> deleteStation(String id, String userId) async {
    try {
      await ApiService.delete('/stations/$id');
    } catch (e) {
      throw Exception(_msg(e));
    }
  }

  @override
  Future<void> deleteAllForUser(String userId) async {
    await LocalStorageService.remove(_key(userId));
  }
}
