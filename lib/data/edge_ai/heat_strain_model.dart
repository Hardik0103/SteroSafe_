import '../../domain/models/vitals_data.dart';
import '../../domain/models/environment_data.dart';

class HeatStrainModel {
  /// Evaluates Physiological Strain Index (PSI: 0 - 10)
  /// Based on Moran et al. physiological model for heat tolerance
  static double calculatePsi({
    required double coreTemp,
    required int heartRate,
    double initialCoreTemp = 36.6,
    int initialHeartRate = 70,
  }) {
    final tempDelta = (coreTemp - initialCoreTemp).clamp(0.0, 3.5);
    final hrDelta = (heartRate - initialHeartRate).clamp(0, 110);

    final psi = (5.0 * (tempDelta / 3.0)) + (5.0 * (hrDelta / 100.0));
    return psi.clamp(0.0, 10.0);
  }

  /// Calculates Heat Stress Risk Percentage (0% - 100%)
  static double calculateHeatStressRisk(VitalsData vitals, EnvironmentData env) {
    // Environmental weight (Heat index > 35°C accelerates strain)
    double envFactor = 0.0;
    if (env.heatIndex > 45.0) {
      envFactor = 45.0;
    } else if (env.heatIndex > 40.0) {
      envFactor = 35.0;
    } else if (env.heatIndex > 35.0) {
      envFactor = 20.0;
    } else {
      envFactor = 10.0;
    }

    // Physiological weight
    double bioFactor = 0.0;
    if (vitals.bodyTemp > 38.5) {
      bioFactor += 35.0;
    } else if (vitals.bodyTemp > 37.5) {
      bioFactor += 20.0;
    } else {
      bioFactor += 5.0;
    }

    if (vitals.heartRate > 115) {
      bioFactor += 20.0;
    } else if (vitals.heartRate > 95) {
      bioFactor += 10.0;
    }

    return (envFactor + bioFactor).clamp(0.0, 100.0);
  }

  /// Calculates Respiratory Distress Risk (0% - 100%)
  static double calculateRespiratoryDistressRisk(VitalsData vitals, EnvironmentData env) {
    double risk = 0.0;
    if (env.aqi > 250) {
      risk += 40.0;
    } else if (env.aqi > 150) {
      risk += 25.0;
    } else {
      risk += 10.0;
    }

    if (vitals.spo2 < 93.0) {
      risk += 40.0;
    } else if (vitals.spo2 < 96.0) {
      risk += 20.0;
    }

    if (vitals.respiratoryRate > 22 || vitals.respiratoryRate < 10) {
      risk += 20.0;
    }

    return risk.clamp(0.0, 100.0);
  }
}
