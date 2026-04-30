import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

MqttClient createMqttClient(String identifier) =>
    MqttServerClient('broker.hivemq.com', identifier)..port = 1883;
