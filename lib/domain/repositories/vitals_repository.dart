import '../models/vitals_data.dart';

abstract class VitalsRepository {
  /// Reactive stream of physiological telemetry from Qualcomm edge sensor hub
  Stream<VitalsData> get vitalsStream;

  /// Current latest physiological data snapshot
  VitalsData get currentVitals;

  /// Ingest raw byte telemetry packet from hardware.
  /// If CRC check fails or sensor disconnects, automatically falls back to simulated buffer.
  void ingestHardwarePacket(List<int> rawPacket, int expectedCrc);

  /// Forces simulation mode toggle
  void setSimulationMode(bool enabled);

  /// Disposes background streams and timers
  void dispose();
}
