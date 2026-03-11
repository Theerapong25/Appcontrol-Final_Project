import 'dart:ui';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final double speed;
  final String status;
  final bool buzzer;
  final double speedLimit;
  final ValueChanged<bool> onBuzzerToggle;

  const HomePage({
    super.key,
    required this.speed,
    required this.status,
    required this.buzzer,
    required this.speedLimit,
    required this.onBuzzerToggle,
  });

  @override
  Widget build(BuildContext context) {
    final bool isOverspeed = status == "OVERSPEED";

    final Color accent =
        isOverspeed ? const Color.fromARGB(255, 255, 13, 0) : const Color.fromARGB(255, 21, 255, 0);

    return Scaffold(
      body: Stack(
        children: [

          
          Positioned.fill(
            child: Image.asset(
              'assets/bg3.jpg',
              fit: BoxFit.cover,
            ),
          ),

          
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX:15,
                sigmaY: 15
                ,
              ),
              child: Container(
                color: const Color.fromARGB(128, 0, 0, 0)
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [

                  const SizedBox(height: 30),

                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SPEED",
                            style: TextStyle(
                              fontSize: 13,
                              letterSpacing: 3,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "Monitor",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          )
                        ],
                      ),

                      _StatusChip(
                        isOverspeed: isOverspeed,
                        accent: accent,
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                
                  _SpeedGauge(
                    speed: speed,
                    speedLimit: speedLimit,
                    accent: accent,
                    isOverspeed: isOverspeed,
                  ),

                  const SizedBox(height: 50),

                  Row(
                    children: [

                      Expanded(
                        child: _InfoCard(
                          label: "Limit",
                          value: speedLimit.toStringAsFixed(0),
                          unit: "km/h",
                          icon: Icons.warning_amber_rounded,
                          iconColor: Colors.orange,
                        ),
                      ),

                      const SizedBox(width: 14),

                      Expanded(
                        child: _InfoCard(
                          label: "Current",
                          value: speed.toStringAsFixed(1),
                          unit: "km/h",
                          icon: Icons.speed,
                          iconColor: accent,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  _BuzzerCard(
                    isOn: buzzer,
                    onToggle: onBuzzerToggle,
                  ),

                  const Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final bool isOverspeed;
  final Color accent;

  const _StatusChip({
    required this.isOverspeed,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accent.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [

          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 6),

          Text(
            isOverspeed ? "OVERSPEED" : "NORMAL",
            style: TextStyle(
              color: accent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          )
        ],
      ),
    );
  }
}

class _SpeedGauge extends StatelessWidget {
  final double speed;
  final double speedLimit;
  final Color accent;
  final bool isOverspeed;

  const _SpeedGauge({
    required this.speed,
    required this.speedLimit,
    required this.accent,
    required this.isOverspeed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [

        Container(
          width: 230,
          height: 230,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 25,
              )
            ],
          ),
        ),

        SizedBox(
          width: 210,
          height: 210,
          child: CircularProgressIndicator(
            value: (speed / (speedLimit * 2)).clamp(0.0, 1.0),
            strokeWidth: 6,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(accent),
            strokeCap: StrokeCap.round,
          ),
        ),

        Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Text(
              speed.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w300,
                color: isOverspeed ? Colors.redAccent : Colors.white,
              ),
            ),

            const Text(
              "km/h",
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 3,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            )
          ],
        )
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color iconColor;

  const _InfoCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(icon, color: iconColor),

          const SizedBox(height: 10),

          RichText(
            text: TextSpan(
              children: [

                TextSpan(
                  text: value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                TextSpan(
                  text: " $unit",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}

class _BuzzerCard extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onToggle;

  const _BuzzerCard({
    required this.isOn,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [

          Icon(
            isOn ? Icons.volume_up : Icons.volume_off,
            color: isOn ? Colors.orange : Colors.white70,
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Text(
              "Buzzer Alert",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),

          Switch(
            value: isOn,
            onChanged: onToggle,
            activeColor: Colors.orange,
          )
        ],
      ),
    );
  }
}