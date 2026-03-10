import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {

  final String clientId;
  final String token;
  final String secret;

  final Function(String device, bool isOn) onDeviceStatusChanged;
  final Function(double speed) onSpeedChanged;

  late MqttServerClient _client;

  MqttService({
    required this.clientId,
    required this.token,
    required this.secret,
    required this.onDeviceStatusChanged,
    required this.onSpeedChanged,
  });

  Future<void> connect() async {

    _client = MqttServerClient('broker.netpie.io', clientId);

    _client.port = 1883;
    _client.keepAlivePeriod = 20;

    _client.autoReconnect = true;
    _client.resubscribeOnAutoReconnect = true;

    _client.logging(on: false);

    _client.onConnected = () {
      print('✅ MQTT Connected');
    };

    _client.onDisconnected = () {
      print('❌ MQTT Disconnected');
    };

    _client.onAutoReconnect = () {
      print('🔄 MQTT Reconnecting...');
    };

    _client.onAutoReconnected = () {
      print('✅ MQTT Reconnected');
    };

    _client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .authenticateAs(token, secret)
        .startClean();

    try {
      await _client.connect();
    } catch (e) {
      print('🚨 MQTT connect error: $e');
      _client.disconnect();
      return;
    }

    if (_client.connectionStatus?.state == MqttConnectionState.connected) {

      // 📡 รับค่าความเร็วจาก ESP32
      _client.subscribe('@msg/lab_ict/speed_data', MqttQos.atMostOnce);

      // 📡 Shadow Sync
      _client.subscribe('@shadow/data/update', MqttQos.atMostOnce);

      _client.updates!.listen(_onMessage);
    }
  }

  // publish control buzzer
  void publishDevice(String device, bool value) {

    if (_client.connectionStatus?.state !=
        MqttConnectionState.connected) {
      print('❌ MQTT not connected');
      return;
    }

    final payload = json.encode({
      "data": {
        device: value ? 1 : 0,
      }
    });

    final builder = MqttClientPayloadBuilder();
    builder.addString(payload);

    _client.publishMessage(
      '@msg/home/device_control',
      MqttQos.atMostOnce,
      builder.payload!,
    );

    print('📤 MQTT OUT: $payload');
  }

  void _onMessage(List<MqttReceivedMessage<MqttMessage>> events) {

    final recMsg = events[0].payload as MqttPublishMessage;

    final payload = MqttPublishPayload.bytesToStringAsString(
      recMsg.payload.message,
    );

    print('📥 MQTT IN: $payload');

    try {

      final decoded = json.decode(payload);

      if (decoded['data'] == null) return;

      final data = decoded['data'];

      // 📊 รับค่า speed
      if (data['speed'] != null) {

        double speed = (data['speed'] as num).toDouble();

        onSpeedChanged(speed);
      }

      // 🔔 device status
      _handleDevice(data, 'buzzer');

    } catch (e) {
      print('🚨 JSON error: $e');
    }
  }

  void _handleDevice(Map<String, dynamic> data, String device) {

    final value = data[device];

    if (value is int) {
      onDeviceStatusChanged(device, value == 1);
    }
  }

  void disconnect() {
    print('🔌 MQTT Disconnect');
    _client.disconnect();
  }
}