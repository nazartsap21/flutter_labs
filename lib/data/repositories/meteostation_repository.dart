import 'package:flutter_lab/data/models/meteostation.dart';

abstract class MeteostationRepository {
  Future<List<Meteostation>> getStations(String userId);
  Future<void> addStation(Meteostation station);
  Future<void> updateStation(Meteostation station);
  Future<void> deleteStation(String id, String userId);
  Future<void> deleteAllForUser(String userId);
}
