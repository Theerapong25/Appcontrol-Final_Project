// lib/models/alert_model.dart
enum AlertSeverity { warning, danger, critical }

class AlertModel {
  final String id;
  final double speed;
  final double speedLimit;
  final DateTime timestamp;
  final AlertSeverity severity;
  final String location;
  final String vehicleId;
  bool isRead;

  AlertModel({
    required this.id,
    required this.speed,
    required this.speedLimit,
    required this.timestamp,
    required this.severity,
    this.location = 'Unknown Location',
    this.vehicleId = 'VH-001',
    this.isRead = false,
  });

  double get excessSpeed => speed - speedLimit;

  String get severityText {
    switch (severity) {
      case AlertSeverity.warning:
        return 'เกินเล็กน้อย';
      case AlertSeverity.danger:
        return 'เกินมาก';
      case AlertSeverity.critical:
        return 'วิกฤต';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speed': speed,
      'speedLimit': speedLimit,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity.index,
      'location': location,
      'vehicleId': vehicleId,
      'isRead': isRead,
    };
  }

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      speed: json['speed'].toDouble(),
      speedLimit: json['speedLimit'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      severity: AlertSeverity.values[json['severity']],
      location: json['location'] ?? 'Unknown Location',
      vehicleId: json['vehicleId'] ?? 'VH-001',
      isRead: json['isRead'] ?? false,
    );
  }
}
