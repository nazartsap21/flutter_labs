import 'package:flutter/foundation.dart';
import 'package:flutter_lab/data/services/mqtt_service.dart';

class MqttProvider extends ChangeNotifier {
  final MqttService _service = MqttService();

  bool _connected = false;
  final Map<String, Map<String, String>> _stationData = {};

  bool get connected => _connected;

  String temperature(String stationId) =>
      _stationData[stationId]?['temperature'] ?? '—';
  String humidity(String stationId) =>
      _stationData[stationId]?['humidity'] ?? '—';
  String wind(String stationId) => _stationData[stationId]?['wind'] ?? '—';

  MqttProvider() {
    _service.onConnected = () {
      _connected = true;
      notifyListeners();
    };
    _service.onDisconnected = () {
      _connected = false;
      notifyListeners();
    };
    _service.onMessage = _handleMessage;
    _connect();
  }

  Future<void> _connect() async {
    await _service.connect();
  }

  Future<void> reconnect() async {
    _service.disconnect();
    await _service.connect();
  }

  void _handleMessage(String topic, String payload) {
    // topic format: sensor/{stationId}/{metric}
    final parts = topic.split('/');
    if (parts.length != 3) return;
    final stationId = parts[1];
    final metric = parts[2];
    (_stationData[stationId] ??= {})[metric] = payload;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.disconnect();
    super.dispose();
  }
}
