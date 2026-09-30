enum AlertSeverity {
  low,
  medium,
  high,
}

enum AlertType {
  heat,
  airQuality,
  flood,
  vitals,
  general,
}

class AlertItem {
  final String id;
  final String title;
  final String description;
  final AlertSeverity severity;
  final AlertType type;
  final DateTime timestamp;
  final String? advice;

  const AlertItem({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.type,
    required this.timestamp,
    this.advice,
  });

  bool get isHighHeatAlert => type == AlertType.heat && severity == AlertSeverity.high;
}
