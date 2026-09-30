class VitalsData {
  final int heartRate; // BPM
  final double spo2; // %
  final double bodyTemp; // °C
  final int respiratoryRate; // /min
  final double fatigueRisk; // % 0-100
  final double fallRisk; // % 0-100
  final double airQualityExposure; // % 0-100
  final List<double> ppgBuffer;
  final bool isSimulated;
  final bool crcValid;
  final DateTime timestamp;

  const VitalsData({
    required this.heartRate,
    required this.spo2,
    required this.bodyTemp,
    required this.respiratoryRate,
    this.fatigueRisk = 24.0,
    this.fallRisk = 8.0,
    this.airQualityExposure = 62.0,
    this.ppgBuffer = const [],
    this.isSimulated = true,
    this.crcValid = true,
    required this.timestamp,
  });

  factory VitalsData.fallbackDefault({bool simulated = true}) {
    return VitalsData(
      heartRate: 72,
      spo2: 98.4,
      bodyTemp: 36.6,
      respiratoryRate: 16,
      fatigueRisk: 24.0,
      fallRisk: 8.0,
      airQualityExposure: 62.0,
      ppgBuffer: List.generate(30, (i) => 0.5 + 0.3 * (i % 5 == 0 ? 1.0 : -0.2)),
      isSimulated: simulated,
      crcValid: true,
      timestamp: DateTime.now(),
    );
  }

  VitalsData copyWith({
    int? heartRate,
    double? spo2,
    double? bodyTemp,
    int? respiratoryRate,
    double? fatigueRisk,
    double? fallRisk,
    double? airQualityExposure,
    List<double>? ppgBuffer,
    bool? isSimulated,
    bool? crcValid,
    DateTime? timestamp,
  }) {
    return VitalsData(
      heartRate: heartRate ?? this.heartRate,
      spo2: spo2 ?? this.spo2,
      bodyTemp: bodyTemp ?? this.bodyTemp,
      respiratoryRate: respiratoryRate ?? this.respiratoryRate,
      fatigueRisk: fatigueRisk ?? this.fatigueRisk,
      fallRisk: fallRisk ?? this.fallRisk,
      airQualityExposure: airQualityExposure ?? this.airQualityExposure,
      ppgBuffer: ppgBuffer ?? this.ppgBuffer,
      isSimulated: isSimulated ?? this.isSimulated,
      crcValid: crcValid ?? this.crcValid,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  String get hrStatus => (heartRate >= 55 && heartRate <= 100) ? "Normal" : (heartRate > 100 ? "Elevated" : "Low");
  String get spo2Status => spo2 >= 95.0 ? "Good" : (spo2 >= 90.0 ? "Moderate" : "Critical");
  String get tempStatus => (bodyTemp >= 36.1 && bodyTemp <= 37.5) ? "Normal" : (bodyTemp > 37.5 ? "Elevated" : "Low");
  String get respStatus => (respiratoryRate >= 12 && respiratoryRate <= 20) ? "Normal" : (respiratoryRate > 20 ? "Rapid" : "Slow");
}
