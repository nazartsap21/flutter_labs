import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

MqttClient createMqttClient(String identifier) =>
    MqttBrowserClient('ws://broker.hivemq.com/mqtt', identifier)..port = 8000;
