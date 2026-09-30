import '../../core/utils/crc_checker.dart';
import '../../core/constants/disaster_thresholds.dart';

class FallDetectionResult {
  final bool fallDetected;
  final bool isCorruptedPacket;
  final bool usedSimulatedFallback;
  final double jerkMagnitudeG;
  final String statusMessage;

  const FallDetectionResult({
    required this.fallDetected,
    required this.isCorruptedPacket,
    required this.usedSimulatedFallback,
    required this.jerkMagnitudeG,
    required this.statusMessage,
  });
}

class FallDetectionPipeline {
  /// Evaluates IMU accelerometer telemetry with CRC verification.
  /// If CRC check fails or buffer is corrupt, gracefully falls back to simulated
  /// stable buffer, completely preventing false-positive SOS triggers.
  static FallDetectionResult processImuPacket({
    required List<int> rawImuPacket,
    required int expectedCrc,
    required double parsedJerkG,
  }) {
    // 1. Verify CRC integrity
    final bool crcValid = CrcChecker.verifyChecksum(rawImuPacket, expectedCrc);

    if (!crcValid) {
      // Hardware failure or disconnect detected!
      // Fallback to simulated buffer to prevent false-positive SOS alert.
      return const FallDetectionResult(
        fallDetected: false,
        isCorruptedPacket: true,
        usedSimulatedFallback: true,
        jerkMagnitudeG: 0.98, // 1G standard gravity fallback
        statusMessage: "CRC check failed: hardware packet corrupt. Fallback to simulated buffer engaged (SOS protected).",
      );
    }

    // 2. High integrity hardware packet: evaluate fall thresholds
    final bool impactDetected = parsedJerkG >= DisasterThresholds.fallJerkThresholdG;

    return FallDetectionResult(
      fallDetected: impactDetected,
      isCorruptedPacket: false,
      usedSimulatedFallback: false,
      jerkMagnitudeG: parsedJerkG,
      statusMessage: impactDetected ? "High-G impact detected" : "Normal movement",
    );
  }
}
