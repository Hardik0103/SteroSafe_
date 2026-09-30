import '../models/sos_event.dart';
import '../models/user_profile.dart';
import '../models/vitals_data.dart';

abstract class SosRepository {
  /// Stream of SOS history and dispatched alerts
  Stream<List<SosEvent>> get sosEventsStream;

  /// Current historical list of SOS events
  List<SosEvent> get historicalEvents;

  /// Logs a false alarm or cancelled SOS event
  void logCancelledSos(String location, VitalsData vitals);

  /// Dispatches an emergency alert to contacts and doctors
  Future<SosEvent> dispatchEmergency({
    required UserProfile profile,
    required VitalsData vitals,
    required String location,
  });

  /// Disposes stream controllers
  void dispose();
}
