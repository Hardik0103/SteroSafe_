import 'package:flutter_test/flutter_test.dart';
import 'package:health_companion/core/utils/crc_checker.dart';
import 'package:health_companion/domain/models/personal_baseline.dart';
import 'package:health_companion/domain/models/vitals_data.dart';
import 'package:health_companion/domain/models/environment_data.dart';
import 'package:health_companion/domain/models/user_profile.dart';
import 'package:health_companion/data/edge_ai/baseline_evaluator.dart';
import 'package:health_companion/data/edge_ai/fall_detection_pipeline.dart';
import 'package:health_companion/data/edge_ai/heat_strain_model.dart';
import 'package:health_companion/data/edge_ai/dehydration_estimator.dart';
import 'package:health_companion/data/repositories/edge_vitals_repository.dart';
import 'package:health_companion/data/repositories/edge_environment_repository.dart';
import 'package:health_companion/data/repositories/edge_sos_repository.dart';
import 'package:health_companion/data/local_storage/health_storage_service.dart';
import 'package:health_companion/presentation/providers/app_state.dart';

void main() {
  group('Edge-AI CRC & Hardware Fallback Tests', () {
    test('CRC-16 verifies valid packet correctly', () {
      final packet = [0x01, 0x02, 0x03, 0x04];
      final crc = CrcChecker.computeCrc16(packet);
      expect(CrcChecker.verifyChecksum(packet, crc), isTrue);
    });

    test('CRC failure triggers simulated buffer fallback and prevents false SOS', () {
      final packet = [0xAA, 0xBB, 0xCC];
      const invalidCrc = 0x1234;

      final result = FallDetectionPipeline.processImuPacket(
        rawImuPacket: packet,
        expectedCrc: invalidCrc,
        parsedJerkG: 3.5, // Even with high jerk, corrupt CRC must not trigger SOS
      );

      expect(result.fallDetected, isFalse);
      expect(result.isCorruptedPacket, isTrue);
      expect(result.usedSimulatedFallback, isTrue);
    });
  });

  group('Personalized Baseline & Lifestyle Evaluation Tests', () {
    test('Runner baseline vs Construction baseline ranges differ', () {
      final runnerBaseline = PersonalBaseline.forLifestyle(LifestyleType.runner);
      final constructionBaseline = PersonalBaseline.forLifestyle(LifestyleType.construction);

      expect(runnerBaseline.restingHrMin, lessThan(constructionBaseline.restingHrMin));
      expect(runnerBaseline.lifestyle, equals(LifestyleType.runner));
      expect(constructionBaseline.lifestyle, equals(LifestyleType.construction));
    });

    test('Baseline evaluator flags construction tachycardia above personal norm', () {
      final constructionBaseline = PersonalBaseline.forLifestyle(LifestyleType.construction);
      final highVitals = VitalsData(
        heartRate: 145,
        spo2: 97.0,
        bodyTemp: 37.1,
        respiratoryRate: 18,
        timestamp: DateTime.now(),
      );
      final env = EnvironmentData.defaultEnvironment();

      final insight = BaselineEvaluator.evaluateHeartRateInsight(highVitals, constructionBaseline, env);
      expect(insight, contains("construction day"));
    });
  });

  group('Heat Stress & Dehydration Edge Models Tests', () {
    test('High heat index triggers elevated heat stress risk', () {
      final vitals = VitalsData.fallbackDefault();
      final highHeatEnv = EnvironmentData(
        ambientTemp: 42.0,
        humidity: 60.0,
        aqi: 180,
        heatIndex: 48.0,
        timestamp: DateTime.now(),
      );

      final risk = HeatStrainModel.calculateHeatStressRisk(vitals, highHeatEnv);
      expect(risk, greaterThanOrEqualTo(50.0));
    });

    test('Low water intake increases dehydration risk', () {
      final vitals = VitalsData.fallbackDefault();
      final env = EnvironmentData.defaultEnvironment();
      final profile = UserProfile.defaultProfile();

      final riskLowWater = DehydrationEstimator.estimateDehydrationRisk(
        waterLoggedTodayMl: 200,
        profile: profile,
        environment: env,
        vitals: vitals,
      );

      final riskHighWater = DehydrationEstimator.estimateDehydrationRisk(
        waterLoggedTodayMl: 2600,
        profile: profile,
        environment: env,
        vitals: vitals,
      );

      expect(riskLowWater, greaterThan(riskHighWater));
    });
  });

  group('AppState & SOS Workflow Tests', () {
    test('SOS cancel logs false alarm without dispatching', () {
      final vitalsRepo = EdgeVitalsRepository();
      final envRepo = EdgeEnvironmentRepository();
      final sosRepo = EdgeSosRepository();
      final storage = HealthStorageService();

      final state = AppState(
        vitalsRepo: vitalsRepo,
        environmentRepo: envRepo,
        sosRepo: sosRepo,
        storageService: storage,
      );

      state.startSosCountdown();
      expect(state.isSosCountdownActive, isTrue);

      state.cancelSosCountdown();
      expect(state.isSosCountdownActive, isFalse);
      expect(state.sosEvents.first.isFalseAlarm, isTrue);

      vitalsRepo.dispose();
      envRepo.dispose();
      sosRepo.dispose();
      state.dispose();
    });
  });
}
