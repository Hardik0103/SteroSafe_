import 'dart:async';
import 'dart:math';
import '../../core/utils/crc_checker.dart';
import '../../domain/models/vitals_data.dart';
import '../../domain/repositories/vitals_repository.dart';

class EdgeVitalsRepository implements VitalsRepository {
  final StreamController<VitalsData> _controller = StreamController<VitalsData>.broadcast();
  Timer? _timer;
  VitalsData _currentVitals = VitalsData.fallbackDefault();
  bool _simulationMode = true;
  double _waveformPhase = 0.0;
  final Random _random = Random();

  EdgeVitalsRepository() {
    _startTelemetryGenerator();
  }

  void _startTelemetryGenerator() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (t) {
      _waveformPhase += 0.25;

      // Realistic PPG waveform simulated frame
      final List<double> ppgPoints = List.generate(40, (i) {
        final x = (i / 5.0) + _waveformPhase;
        // Systolic peak + dicrotic notch
        return (sin(x) * 0.5) + (sin(2 * x) * 0.25) + 0.5;
      });

      // Subtle natural fluctuations
      final hrFluct = (_random.nextInt(3) - 1);
      final newHr = (_currentVitals.heartRate + hrFluct).clamp(68, 88);

      _currentVitals = _currentVitals.copyWith(
        heartRate: newHr,
        spo2: 98.2 + (_random.nextDouble() * 0.4),
        bodyTemp: 36.6 + (_random.nextDouble() * 0.2),
        respiratoryRate: 16 + (_random.nextInt(3) - 1),
        ppgBuffer: ppgPoints,
        isSimulated: _simulationMode,
        crcValid: true,
        timestamp: DateTime.now(),
      );

      _controller.add(_currentVitals);
    });
  }

  @override
  Stream<VitalsData> get vitalsStream => _controller.stream;

  @override
  VitalsData get currentVitals => _currentVitals;

  @override
  void ingestHardwarePacket(List<int> rawPacket, int expectedCrc) {
    final bool valid = CrcChecker.verifyChecksum(rawPacket, expectedCrc);
    if (!valid) {
      // Hardware failure/corrupted packet: smoothly fall back to simulated buffer
      _simulationMode = true;
      _currentVitals = _currentVitals.copyWith(
        isSimulated: true,
        crcValid: false,
        timestamp: DateTime.now(),
      );
      _controller.add(_currentVitals);
      return;
    }

    // Packet is valid hardware packet
    _simulationMode = false;
    _currentVitals = _currentVitals.copyWith(
      isSimulated: false,
      crcValid: true,
      timestamp: DateTime.now(),
    );
    _controller.add(_currentVitals);
  }

  @override
  void setSimulationMode(bool enabled) {
    _simulationMode = enabled;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.close();
  }
}
