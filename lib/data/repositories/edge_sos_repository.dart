import 'dart:async';
import '../../domain/models/sos_event.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/vitals_data.dart';
import '../../domain/repositories/sos_repository.dart';

class EdgeSosRepository implements SosRepository {
  final StreamController<List<SosEvent>> _controller = StreamController<List<SosEvent>>.broadcast();
  final List<SosEvent> _events = [];

  EdgeSosRepository() {
    // Seed initial event for verification
    _events.add(
      SosEvent(
        id: "sos-init-1",
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        status: SosStatus.cancelled,
        location: "Lat: 28.6139° N, Lon: 77.2090° E (New Delhi)",
        vitalsSummary: "HR: 76 bpm, SpO2: 98%, Temp: 36.6°C",
        note: "Emergency cancelled by user within 15-second safety countdown (False Alarm).",
      ),
    );
  }

  @override
  Stream<List<SosEvent>> get sosEventsStream => _controller.stream;

  @override
  List<SosEvent> get historicalEvents => List.unmodifiable(_events);

  @override
  void logCancelledSos(String location, VitalsData vitals) {
    final event = SosEvent(
      id: "sos-${DateTime.now().millisecondsSinceEpoch}",
      timestamp: DateTime.now(),
      status: SosStatus.cancelled,
      location: location,
      vitalsSummary: "HR: ${vitals.heartRate} bpm, SpO2: ${vitals.spo2.toStringAsFixed(1)}%, Temp: ${vitals.bodyTemp.toStringAsFixed(1)}°C",
      note: "Emergency cancelled by user within 15s countdown window. False alarm logged.",
    );
    _events.insert(0, event);
    _controller.add(List.unmodifiable(_events));
  }

  @override
  Future<SosEvent> dispatchEmergency({
    required UserProfile profile,
    required VitalsData vitals,
    required String location,
  }) async {
    final contactsStr = profile.emergencyContacts.map((c) => "${c.name} (${c.phone})").join(", ");
    final event = SosEvent(
      id: "sos-${DateTime.now().millisecondsSinceEpoch}",
      timestamp: DateTime.now(),
      status: SosStatus.sent,
      location: location,
      vitalsSummary: "HR: ${vitals.heartRate} bpm, SpO2: ${vitals.spo2.toStringAsFixed(1)}%, Temp: ${vitals.bodyTemp.toStringAsFixed(1)}°C",
      note: "CRITICAL: Offline Emergency Broadcast dispatched to: $contactsStr and Dr. ${profile.doctorName}. Patient conditions: ${profile.healthConditions.join(', ')}. Allergies: ${profile.allergies.join(', ')}.",
    );
    _events.insert(0, event);
    _controller.add(List.unmodifiable(_events));
    return event;
  }

  @override
  void dispose() {
    _controller.close();
  }
}
