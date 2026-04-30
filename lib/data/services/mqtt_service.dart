import 'package:flutter_lab/data/services/mqtt_factory.dart'
    if (dart.library.io) 'package:flutter_lab/data/services/mqtt_factory_io.dart'
    if (dart.library.js_interop) 'package:flutter_lab/data/services/mqtt_factory_web.dart';
import 'package:mqtt_client/mqtt_client.dart';

typedef MqttMessageCallback = void Function(String topic, String payload);

class MqttService {
  static const List<String> _wildcardTopics = [
    'sensor/+/temperature',
    'sensor/+/humidity',
    'sensor/+/wind',
  ];

  final MqttClient _client;

  MqttMessageCallback? onMessage;
  void Function()? onConnected;
  void Function()? onDisconnected;

  MqttService()
      : _client = createMqttClient(
          'flutter_lab_${DateTime.now().millisecondsSinceEpoch}',
        );

  bool get isConnected =>
      _client.connectionStatus?.state == MqttConnectionState.connected;

  Future<void> connect() async {
    _client.logging(on: false);
    _client.keepAlivePeriod = 20;
    _client.autoReconnect = true;
    _client.onConnected = onConnected;
    _client.onDisconnected = onDisconnected;

    final connMsg = MqttConnectMessage()
        .withClientIdentifier(_client.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);
    _client.connectionMessage = connMsg;

    try {
      await _client.connect();
    } catch (_) {
      _client.disconnect();
      return;
    }

    if (!isConnected) return;

    for (final topic in _wildcardTopics) {
      _client.subscribe(topic, MqttQos.atMostOnce);
    }

    _client.updates?.listen((messages) {
      for (final msg in messages) {
        final publish = msg.payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          publish.payload.message,
        );
        onMessage?.call(msg.topic, payload);
      }
    });
  }

  void disconnect() {
    _client.disconnect();
  }
}
