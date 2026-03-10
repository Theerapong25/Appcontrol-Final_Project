import 'package:flutter/material.dart';
import 'mqtt_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MqttService _mqtt;

  final String mobileClientId = 'c0386942-6b21-45c2-a61d-f4a221bd60d6';
  final String mobileToken = 'osSazpFjV7sxE64q8Q6ZDjcaunQAayqo';
  final String mobileSecret = '6gj8xgaUHRZrrbaNAyL8U8HXSeKAAPK7';

  double speed = 0.0;
  String status = "NORMAL";
  bool buzzer = false;

  @override
  void initState() {
    super.initState();

    _mqtt = MqttService(
      clientId: mobileClientId,
      token: mobileToken,
      secret: mobileSecret,
      onSpeedChanged: (double newSpeed) {
        setState(() {
          speed = newSpeed;

          if (speed > 2) {
            status = "OVERSPEED";
          } else {
            status = "NORMAL";
          }
        });
      },

      onDeviceStatusChanged: (device, isOn) {
        if (device == "buzzer") {
          setState(() {
            buzzer = isOn;
          });
        }
      },
    );

    _mqtt.connect();
  }

  @override
  void dispose() {
    _mqtt.disconnect();
    super.dispose();
  }

  Future<void> _toggleBuzzer(bool value) async {
    _mqtt.publishDevice("buzzer", value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Speed Monitor"),
        backgroundColor: Colors.blue,
      ),

      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          elevation: 5,

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Vehicle Speed",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                Text(
                  "${speed.toStringAsFixed(2)} km/h",
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  status,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: status == "OVERSPEED" ? Colors.red : Colors.green,
                  ),
                ),

                const SizedBox(height: 30),

                const Divider(),

                const SizedBox(height: 20),

                Text(
                  buzzer ? "Buzzer ON" : "Buzzer OFF",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Switch(
                  value: buzzer,
                  onChanged: _toggleBuzzer,
                  activeColor: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
