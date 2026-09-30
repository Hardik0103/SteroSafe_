import '../../domain/models/vitals_data.dart';
import '../../domain/models/environment_data.dart';
import '../../domain/models/user_profile.dart';

class DehydrationEstimator {
  /// Estimates dehydration risk percentage (0 - 100%)
  static double estimateDehydrationRisk({
    required int waterLoggedTodayMl,
    required UserProfile profile,
    required EnvironmentData environment,
    required VitalsData vitals,
  }) {
    // 1. Water intake deficit factor
    final target = profile.dailyHydrationGoalMl;
    final deficitRatio = (1.0 - (waterLoggedTodayMl / target)).clamp(0.0, 1.0);
    double intakeFactor = deficitRatio * 50.0;

    // 2. Weather & temperature evaporation factor
    double weatherFactor = 0.0;
    if (environment.heatIndex > 40.0) {
      weatherFactor = 30.0;
    } else if (environment.heatIndex > 35.0) {
      weatherFactor = 20.0;
    } else if (environment.ambientTemp > 32.0) {
      weatherFactor = 10.0;
    }

    // 3. Heart rate drift / sweat strain factor
    double strainFactor = 0.0;
    if (vitals.heartRate > 100 && vitals.bodyTemp > 37.2) {
      strainFactor = 20.0;
    } else if (vitals.heartRate > 90) {
      strainFactor = 10.0;
    }

    final totalRisk = intakeFactor + weatherFactor + strainFactor;
    return totalRisk.clamp(0.0, 100.0);
  }
}
