import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mqtt_service.dart';
import 'home_page.dart';
import 'history_page.dart';
import 'settings_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  late MqttService _mqtt;
  final String mobileClientId = 'c0386942-6b21-45c2-a61d-f4a221bd60d6';
  final String mobileToken = 'osSazpFjV7sxE64q8Q6ZDjcaunQAayqo';
  final String mobileSecret = '6gj8xgaUHRZrrbaNAyL8U8HXSeKAAPK7';
  
  double speed = 0.0;
  String status = "NORMAL";
  bool buzzer = false;
  double speedLimit = 2.0;

  List<AlertRecord> alertHistory = [];

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _mqtt = MqttService(
      clientId: mobileClientId,
      token: mobileToken,
      secret: mobileSecret,

      /// SPEED CALLBACK
      onSpeedChanged: (double newSpeed) {
        if (!mounted) return;

        setState(() {
          speed = newSpeed;
        });
      },
      onStatusChanged: (String newStatus) {
        if (!mounted) return;

        setState(() {
          status = newStatus;

          if (status == "OVERSPEED" || status == "WRONG WAY") {

            alertHistory.insert(
              0,
              AlertRecord(
                speed: speed,
                limit: speedLimit,
                timestamp: DateTime.now(),
              ),
            );

          }
        });
      },

      /// DEVICE CALLBACK
      onDeviceStatusChanged: (device, isOn) {

        if (!mounted) return;

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

 
  void _updateSpeedLimit(double newLimit) {

    setState(() {
      speedLimit = newLimit;
    });

  }

 
  void _toggleBuzzer(bool value) {

    setState(() {
      buzzer = value;
    });

    _mqtt.publishDevice("buzzer", value);

  }

  /// CLEAR HISTORY
  void _clearHistory() {

    setState(() {
      alertHistory.clear();
    });

  }

  @override
  Widget build(BuildContext context) {

    final pages = [

      HomePage(
        speed: speed,
        status: status,
        buzzer: buzzer,
        speedLimit: speedLimit,
        onBuzzerToggle: _toggleBuzzer,
      ),

      HistoryPage(
        history: alertHistory,
        onClear: _clearHistory,
      ),

      SettingsPage(
        speedLimit: speedLimit,
        onSpeedLimitChanged: _updateSpeedLimit,
      ),

    ];

    return Scaffold(

      backgroundColor: Colors.white,

      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),

      bottomNavigationBar: _buildBottomNav(),

    );
  }

  Widget _buildBottomNav() {

    return Container(

      decoration: BoxDecoration(
        color: const Color(0xFF111118),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
      ),

      child: SafeArea(

        child: Padding(

          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

          child: Row(

            mainAxisAlignment: MainAxisAlignment.spaceAround,

            children: [

              _NavItem(
                icon: Icons.speed_rounded,
                label: 'Monitor',
                isSelected: _currentIndex == 0,
                onTap: () => setState(() => _currentIndex = 0),
              ),

              _NavItem(
                icon: Icons.notifications_outlined,
                label: 'History',
                isSelected: _currentIndex == 1,
                badge: alertHistory.isNotEmpty ? alertHistory.length : null,
                onTap: () => setState(() => _currentIndex = 1),
              ),

              _NavItem(
                icon: Icons.tune_rounded,
                label: 'Settings',
                isSelected: _currentIndex == 2,
                onTap: () => setState(() => _currentIndex = 2),
              ),

            ],

          ),

        ),

      ),

    );
  }

}

class _NavItem extends StatelessWidget {

  final IconData icon;
  final String label;
  final bool isSelected;
  final int? badge;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      behavior: HitTestBehavior.opaque,

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            Stack(

              clipBehavior: Clip.none,

              children: [

                Icon(
                  icon,
                  size: 22,
                  color: isSelected ? Colors.white : Colors.white38,
                ),

                if (badge != null)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF3B30),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          badge! > 9 ? '9+' : '$badge',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

              ],

            ),

            const SizedBox(height: 4),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white : Colors.white38,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),

          ],

        ),

      ),

    );
  }
}

class AlertRecord {

  final double speed;
  final double limit;
  final DateTime timestamp;

  AlertRecord({
    required this.speed,
    required this.limit,
    required this.timestamp,
  });

}