part of 'station_cubit.dart';

sealed class StationState {
  const StationState();
}

final class StationInitial extends StationState {
  const StationInitial();
}

final class StationLoading extends StationState {
  const StationLoading();
}

final class StationLoaded extends StationState {
  const StationLoaded(this.stations);

  final List<Meteostation> stations;
}

final class StationError extends StationState {
  const StationError(this.message);

  final String message;
}
