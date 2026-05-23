import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lab/data/models/meteostation.dart';
import 'package:flutter_lab/data/repositories/meteostation_repository.dart';

part 'station_state.dart';

class StationCubit extends Cubit<StationState> {
  StationCubit(this._repository) : super(const StationInitial());

  final MeteostationRepository _repository;

  Future<void> loadStations(String userId) async {
    emit(const StationLoading());
    try {
      final stations = await _repository.getStations(userId);
      emit(StationLoaded(stations));
    } on Exception catch (e) {
      emit(
        StationError(e.toString().replaceFirst('Exception: ', '')),
      );
    }
  }

  Future<void> addStation(Meteostation station) async {
    await _repository.addStation(station);
    await loadStations(station.userId);
  }

  Future<void> updateStation(Meteostation station) async {
    await _repository.updateStation(station);
    await loadStations(station.userId);
  }

  Future<void> deleteStation(String id, String userId) async {
    await _repository.deleteStation(id, userId);
    await loadStations(userId);
  }

  Future<void> deleteAllForUser(String userId) async {
    await _repository.deleteAllForUser(userId);
    emit(const StationLoaded([]));
  }
}
