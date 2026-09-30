import 'dart:async';
import '../../domain/models/environment_data.dart';
import '../../domain/models/alert_item.dart';
import '../../domain/repositories/environment_repository.dart';

class EdgeEnvironmentRepository implements EnvironmentRepository {
  final StreamController<EnvironmentData> _envController = StreamController<EnvironmentData>.broadcast();
  final StreamController<List<AlertItem>> _alertsController = StreamController<List<AlertItem>>.broadcast();

  EnvironmentData _currentEnvironment = EnvironmentData.defaultEnvironment();
  List<AlertItem> _alerts = [];
  Timer? _timer;

  EdgeEnvironmentRepository() {
    _initializeAlerts();
    _startEnvironmentMonitor();
  }

  void _initializeAlerts() {
    _alerts = [
      AlertItem(
        id: "alert-heat-1",
        title: "High Heat Exposure",
        description: "Ambient temperature and heat index are elevated. Consider moving to a cooler environment.",
        severity: AlertSeverity.high,
        type: AlertType.heat,
        timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
        advice: "Seek shade immediately, consume ORS/electrolyte fluids, and pause vigorous exertion.",
      ),
      AlertItem(
        id: "alert-aqi-1",
        title: "Air Quality Alert (PM2.5 Elevated)",
        description: "PM2.5 levels exceed healthy limits (AQI 158). Wear N95 protection outdoors.",
        severity: AlertSeverity.medium,
        type: AlertType.airQuality,
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        advice: "Limit outdoor aerobic exposure and keep windows sealed.",
      ),
      AlertItem(
        id: "alert-flood-1",
        title: "Monsoon Vector Advisory",
        description: "Post-rain standing water alert in local sector. Avoid waterlogging contact.",
        severity: AlertSeverity.low,
        type: AlertType.flood,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        advice: "Ensure boiled drinking water and use mosquito repellent.",
      ),
    ];
  }

  void _startEnvironmentMonitor() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 4), (t) {
      // Periodic slight variance reflecting local sensors
      _currentEnvironment = EnvironmentData(
        ambientTemp: 34.4,
        humidity: 68.5,
        aqi: 158,
        heatIndex: 41.5,
        pm25: 78.4,
        pm10: 125.0,
        timestamp: DateTime.now(),
      );
      _envController.add(_currentEnvironment);
      _alertsController.add(_alerts);
    });
  }

  @override
  Stream<EnvironmentData> get environmentStream => _envController.stream;

  @override
  EnvironmentData get currentEnvironment => _currentEnvironment;

  @override
  Stream<List<AlertItem>> get disasterAlertsStream => _alertsController.stream;

  @override
  List<AlertItem> get currentAlerts => List.unmodifiable(_alerts);

  @override
  void dispose() {
    _timer?.cancel();
    _envController.close();
    _alertsController.close();
  }
}
