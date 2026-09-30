enum LifestyleType {
  runner,
  office,
  construction,
  student,
  elderly,
  driver,
  other,
}

extension LifestyleTypeExt on LifestyleType {
  String get displayName {
    switch (this) {
      case LifestyleType.runner:
        return "Runner / Athlete";
      case LifestyleType.office:
        return "Office Worker";
      case LifestyleType.construction:
        return "Construction / Manual Labor";
      case LifestyleType.student:
        return "Student";
      case LifestyleType.elderly:
        return "Elderly / Retired";
      case LifestyleType.driver:
        return "Driver / Transit";
      case LifestyleType.other:
        return "General";
    }
  }
}

class PersonalBaseline {
  final LifestyleType lifestyle;
  final int restingHrMin;
  final int restingHrMax;
  final int workingHrMin;
  final int workingHrMax;
  final int maxSafeHr;
  final double baselineHydrationMl;
  final String lifestyleDescription;

  const PersonalBaseline({
    required this.lifestyle,
    required this.restingHrMin,
    required this.restingHrMax,
    required this.workingHrMin,
    required this.workingHrMax,
    required this.maxSafeHr,
    required this.baselineHydrationMl,
    required this.lifestyleDescription,
  });

  factory PersonalBaseline.forLifestyle(LifestyleType type, {int age = 30}) {
    switch (type) {
      case LifestyleType.runner:
        return const PersonalBaseline(
          lifestyle: LifestyleType.runner,
          restingHrMin: 44,
          restingHrMax: 60,
          workingHrMin: 110,
          workingHrMax: 165,
          maxSafeHr: 185,
          baselineHydrationMl: 3200,
          lifestyleDescription: "Low resting HR baseline with wide athletic aerobic range.",
        );
      case LifestyleType.construction:
        return const PersonalBaseline(
          lifestyle: LifestyleType.construction,
          restingHrMin: 64,
          restingHrMax: 82,
          workingHrMin: 95,
          workingHrMax: 135,
          maxSafeHr: 165,
          baselineHydrationMl: 3800,
          lifestyleDescription: "Elevated daytime metabolic exertion. Vulnerable to heat & dehydration.",
        );
      case LifestyleType.elderly:
        return const PersonalBaseline(
          lifestyle: LifestyleType.elderly,
          restingHrMin: 58,
          restingHrMax: 78,
          workingHrMin: 75,
          workingHrMax: 105,
          maxSafeHr: 140,
          baselineHydrationMl: 2200,
          lifestyleDescription: "Narrow cardiac reserve. Heightened sensitivity to extreme weather.",
        );
      case LifestyleType.driver:
        return const PersonalBaseline(
          lifestyle: LifestyleType.driver,
          restingHrMin: 65,
          restingHrMax: 84,
          workingHrMin: 75,
          workingHrMax: 100,
          maxSafeHr: 155,
          baselineHydrationMl: 2500,
          lifestyleDescription: "Sedentary prolonged postures. Monitored for fatigue and heat buildup.",
        );
      case LifestyleType.student:
        return const PersonalBaseline(
          lifestyle: LifestyleType.student,
          restingHrMin: 60,
          restingHrMax: 80,
          workingHrMin: 80,
          workingHrMax: 120,
          maxSafeHr: 175,
          baselineHydrationMl: 2400,
          lifestyleDescription: "Variable activity schedule with mental stress sensitivity.",
        );
      case LifestyleType.office:
      case LifestyleType.other:
        return const PersonalBaseline(
          lifestyle: LifestyleType.office,
          restingHrMin: 60,
          restingHrMax: 80,
          workingHrMin: 75,
          workingHrMax: 115,
          maxSafeHr: 170,
          baselineHydrationMl: 2500,
          lifestyleDescription: "Standard adult baseline with indoor sedentary balance.",
        );
    }
  }

  /// Evaluates HR percentage relative to personalized normal midpoint.
  int percentDeviationFromNorm(int hr) {
    final mid = (restingHrMin + restingHrMax) / 2;
    return (((hr - mid) / mid) * 100).round();
  }
}
