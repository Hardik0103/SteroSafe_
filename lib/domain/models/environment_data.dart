class EnvironmentData {
  final double ambientTemp; // °C
  final double humidity; // %
  final int aqi; // AQI
  final double heatIndex; // °C
  final double pm25; // µg/m³
  final double pm10; // µg/m³
  final DateTime timestamp;

  const EnvironmentData({
    required this.ambientTemp,
    required this.humidity,
    required this.aqi,
    required this.heatIndex,
    this.pm25 = 75.0,
    this.pm10 = 120.0,
    required this.timestamp,
  });

  factory EnvironmentData.defaultEnvironment() {
    return EnvironmentData(
      ambientTemp: 34.2,
      humidity: 68.0,
      aqi: 158,
      heatIndex: 41.5,
      pm25: 78.4,
      pm10: 125.0,
      timestamp: DateTime.now(),
    );
  }

  String get tempStatus => ambientTemp > 38.0 ? "Severe" : (ambientTemp > 32.0 ? "Elevated" : "Moderate");
  String get humidityStatus => humidity > 70.0 ? "High" : (humidity > 40.0 ? "Moderate" : "Low");
  String get aqiStatus => aqi > 300 ? "Severe" : (aqi > 200 ? "Very Poor" : (aqi > 100 ? "Moderate" : "Good"));
  String get heatIndexStatus => heatIndex >= 41.0 ? "Danger" : (heatIndex >= 32.0 ? "Caution" : "Normal");

  bool get isElevatedRisk => heatIndex >= 38.0 || aqi >= 150 || ambientTemp >= 35.0;
}
