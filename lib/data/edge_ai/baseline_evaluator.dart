import '../../domain/models/personal_baseline.dart';
import '../../domain/models/vitals_data.dart';
import '../../domain/models/environment_data.dart';

class BaselineEvaluator {
  /// Evaluates heart rate relative to personal baseline and provides contextual insights.
  static String evaluateHeartRateInsight(
    VitalsData vitals,
    PersonalBaseline baseline,
    EnvironmentData environment,
  ) {
    final hr = vitals.heartRate;
    final int percentDiff = baseline.percentDeviationFromNorm(hr);

    switch (baseline.lifestyle) {
      case LifestyleType.construction:
        if (hr > baseline.workingHrMax) {
          return "Your heart rate was $percentDiff% above your normal for a construction day. Drink more water and take breaks.";
        } else if (environment.heatIndex >= 40.0) {
          return "High environmental heat index (${environment.heatIndex.toStringAsFixed(1)}°C). Your cardiac load is elevated for manual labor.";
        }
        return "Heart rate ($hr BPM) is within expected working parameters for manual labor.";

      case LifestyleType.runner:
        if (hr < baseline.restingHrMin) {
          return "Deep athletic recovery observed ($hr BPM). Optimal cardiac rest.";
        } else if (hr > baseline.workingHrMax) {
          return "Heart rate reached $hr BPM during peak training. Ensure electrolyte replenishment.";
        }
        return "Cardiac metrics align with athletic baseline standards.";

      case LifestyleType.elderly:
        if (hr > baseline.workingHrMax || hr < baseline.restingHrMin) {
          return "Heart rate ($hr BPM) is outside your safe elderly baseline range (${baseline.restingHrMin}-${baseline.workingHrMax} BPM). Rest in a cool area.";
        }
        return "Stable vital signs observed within your personal senior baseline.";

      case LifestyleType.driver:
        if (vitals.fatigueRisk > 50) {
          return "Elevated driving fatigue detected ($hr BPM steady with prolonged stillness). Recommend pulling over for rest.";
        }
        return "Vitals consistent with driver baseline guidelines.";

      case LifestyleType.office:
      case LifestyleType.student:
      case LifestyleType.other:
        if (hr > baseline.restingHrMax + 15) {
          return "Your heart rate was $percentDiff% above your normal resting range. Consider hydration and taking a brief pause.";
        }
        return "Heart rate ($hr BPM) is optimal relative to your daily desk baseline.";
    }
  }

  /// Calculates tachycardia risk status against personalized boundary
  static bool isTachycardia(VitalsData vitals, PersonalBaseline baseline) {
    return vitals.heartRate > baseline.maxSafeHr;
  }
}
