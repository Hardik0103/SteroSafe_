enum SosStatus {
  sent,
  cancelled,
}

class SosEvent {
  final String id;
  final DateTime timestamp;
  final SosStatus status;
  final String location;
  final String vitalsSummary;
  final String note;

  const SosEvent({
    required this.id,
    required this.timestamp,
    required this.status,
    required this.location,
    required this.vitalsSummary,
    this.note = "",
  });

  bool get isFalseAlarm => status == SosStatus.cancelled;

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'status': status.name,
    'location': location,
    'vitalsSummary': vitalsSummary,
    'note': note,
  };

  factory SosEvent.fromJson(Map<String, dynamic> json) => SosEvent(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    status: json['status'] == 'sent' ? SosStatus.sent : SosStatus.cancelled,
    location: json['location'] as String,
    vitalsSummary: json['vitalsSummary'] as String,
    note: json['note'] as String? ?? "",
  );
}
