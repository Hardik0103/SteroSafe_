class HydrationEntry {
  final String id;
  final DateTime timestamp;
  final int amountMl;

  const HydrationEntry({
    required this.id,
    required this.timestamp,
    required this.amountMl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'amountMl': amountMl,
  };

  factory HydrationEntry.fromJson(Map<String, dynamic> json) => HydrationEntry(
    id: json['id'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    amountMl: json['amountMl'] as int,
  );
}
