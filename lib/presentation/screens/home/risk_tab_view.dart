import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/vitals_data.dart';
import '../../../domain/models/environment_data.dart';
import '../../../domain/models/user_profile.dart';
import '../../../data/edge_ai/heat_strain_model.dart';
import '../../../data/edge_ai/dehydration_estimator.dart';
import '../../widgets/progress_risk_card.dart';

class RiskTabView extends StatelessWidget {
  final VitalsData vitals;
  final EnvironmentData environment;
  final UserProfile profile;
  final int waterLoggedToday;

  const RiskTabView({
    super.key,
    required this.vitals,
    required this.environment,
    required this.profile,
    required this.waterLoggedToday,
  });

  @override
  Widget build(BuildContext context) {
    final heatStressRisk = HeatStrainModel.calculateHeatStressRisk(vitals, environment);
    final dehydrationRisk = DehydrationEstimator.estimateDehydrationRisk(
      waterLoggedTodayMl: waterLoggedToday,
      profile: profile,
      environment: environment,
      vitals: vitals,
    );
    final respiratoryRisk = HeatStrainModel.calculateRespiratoryDistressRisk(vitals, environment);
    final abnormalVitalsRisk = (vitals.hrStatus != "Normal" || vitals.spo2 < 95.0) ? 68.0 : 18.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // "Environmental Risk Elevated" banner
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.dangerRed.withValues(alpha: 0.35)),
          ),
          child: const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppTheme.dangerRed, size: 24),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Environmental Risk Elevated",
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.dangerDarkRed,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Heat index & particulate exposure trigger increased physiological strain warning.",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFFB91C1C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Progress-bar cards for Heat Stress, Dehydration, Respiratory Distress, Abnormal Vitals
        ProgressRiskCard(
          title: "Heat Stress",
          valuePercent: heatStressRisk,
          barColor: heatStressRisk > 60 ? AppTheme.dangerRed : AppTheme.warningAmber,
          subtitle: "Combined wet bulb temperature + core thermal load",
        ),
        ProgressRiskCard(
          title: "Dehydration",
          valuePercent: dehydrationRisk,
          barColor: dehydrationRisk > 50 ? AppTheme.warningAmber : AppTheme.primaryBlue,
          subtitle: "Fluid intake deficit vs. ambient sweat rate estimate",
        ),
        ProgressRiskCard(
          title: "Respiratory Distress",
          valuePercent: respiratoryRisk,
          barColor: respiratoryRisk > 50 ? AppTheme.warningAmber : AppTheme.accentCyan,
          subtitle: "Particulate index (AQI ${environment.aqi}) & SpO₂ oxygenation",
        ),
        ProgressRiskCard(
          title: "Abnormal Vitals",
          valuePercent: abnormalVitalsRisk,
          barColor: abnormalVitalsRisk > 50 ? AppTheme.dangerRed : AppTheme.successGreen,
          subtitle: "Continuous deviation from ${profile.lifestyle.name} baseline norm",
        ),
      ],
    );
  }
}

