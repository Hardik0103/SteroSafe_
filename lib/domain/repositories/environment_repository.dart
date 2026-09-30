import '../models/environment_data.dart';
import '../models/alert_item.dart';

abstract class EnvironmentRepository {
  /// Stream of ambient environmental conditions (Temp, Humidity, AQI, Heat Index)
  Stream<EnvironmentData> get environmentStream;

  /// Current snapshot of ambient conditions
  EnvironmentData get currentEnvironment;

  /// Stream of active climate and disaster alerts (Heat wave, PM2.5, Cyclone, Flood)
  Stream<List<AlertItem>> get disasterAlertsStream;

  /// Current list of active disaster alerts
  List<AlertItem> get currentAlerts;

  /// Disposes resources
  void dispose();
}
