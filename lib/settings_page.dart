import 'dart:ui';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final double speedLimit;
  final ValueChanged<double> onSpeedLimitChanged;

  const SettingsPage({
    super.key,
    required this.speedLimit,
    required this.onSpeedLimitChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  late double _localLimit;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _localLimit = widget.speedLimit;
    _controller = TextEditingController(
      text: widget.speedLimit.toStringAsFixed(0),
    );
  }

  void _applyLimit() {
    final val = double.tryParse(_controller.text);
    if (val != null && val > 0) {
      setState(() => _localLimit = val);
      widget.onSpeedLimitChanged(val);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Settings Saved"),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: [

          /// Background
          Positioned.fill(
            child: Image.asset(
              "assets/bg3.jpg",
              fit: BoxFit.cover,
            ),
          ),

          /// Blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
              child: Container(
                color: const Color.fromARGB(168, 0, 0, 0)
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const SizedBox(height: 30),

                  /// HEADER
                  const Text(
                    "CONFIG",
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 3,
                      color: Colors.white70,
                    ),
                  ),

                  const Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 40),

                  
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: const [
                            Icon(Icons.speed,color: Colors.orange),
                            SizedBox(width:10),
                            Text(
                              "Overspeed Limit (Beta !!!)",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          "Alert when speed exceeds this value",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// SLIDER
                        Slider(
                          value: _localLimit.clamp(1,120),
                          min: 1,
                          max: 120,
                          divisions: 119,
                          activeColor: Colors.orange,
                          inactiveColor: Colors.white24,
                          onChanged: (val){
                            setState(() {
                              _localLimit = val;
                              _controller.text = val.toStringAsFixed(0);
                            });
                          },
                        ),

                        const SizedBox(height: 10),

                        /// INPUT
                        Row(
                          children: [

                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal:14),
                                    suffixText: "km/h",
                                    suffixStyle: TextStyle(color: Colors.white70),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            ElevatedButton(
                              onPressed: _applyLimit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(horizontal:20,vertical:14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Apply",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                 
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: const Column(
                      children: [

                        Row(
                          children: [
                            Icon(Icons.bluetooth,color: Colors.blue),
                            SizedBox(width:10),
                            Text(
                              "MQTT Connected",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),

                        SizedBox(height:12),

                        Row(
                          children: [
                            Icon(Icons.info,color: Colors.white70),
                            SizedBox(width:10),
                            Text(
                              "Version 1.0.0",
                              style: TextStyle(color: Colors.white70),
                            )
                          ],
                        )
                      ],
                    ),
                  ),

                  const Spacer()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}