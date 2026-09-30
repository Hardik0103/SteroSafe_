import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/vitals_data.dart';
import '../../widgets/metric_card.dart';
import '../../widgets/progress_risk_card.dart';
import 'ppg_telemetry_card.dart';

class VitalsTabView extends StatelessWidget {
  final VitalsData vitals;

  const VitalsTabView({
    super.key,
    required this.vitals,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2x2 Grid of cards
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: "Heart Rate",
                value: "${vitals.heartRate}",
                unit: "BPM",
                statusText: vitals.hrStatus,
                statusColor: vitals.hrStatus == "Normal" ? AppTheme.successGreen : AppTheme.dangerRed,
                icon: Icons.favorite_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                title: "SpO₂",
                value: vitals.spo2.toStringAsFixed(1),
                unit: "%",
                statusText: vitals.spo2Status,
                statusColor: vitals.spo2 >= 95 ? AppTheme.successGreen : AppTheme.warningAmber,
                icon: Icons.water_drop_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: "Body Temp",
                value: vitals.bodyTemp.toStringAsFixed(1),
                unit: "°C",
                statusText: vitals.tempStatus,
                statusColor: vitals.tempStatus == "Normal" ? AppTheme.successGreen : AppTheme.dangerRed,
                icon: Icons.thermostat_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                title: "Respiratory",
                value: "${vitals.respiratoryRate}",
                unit: "/min",
                statusText: vitals.respStatus,
                statusColor: vitals.respStatus == "Normal" ? AppTheme.successGreen : AppTheme.warningAmber,
                icon: Icons.air_rounded,
              ),
            ),
          ],
        ),

        // PPG Telemetry Card with SIMULATED badge & waveform
        PpgTelemetryCard(
          ppgBuffer: vitals.ppgBuffer,
          isSimulated: vitals.isSimulated,
        ),

        // Progress-bar cards: Fatigue, Fall Risk, Air Quality Exposure
        ProgressRiskCard(
          title: "Fatigue",
          valuePercent: vitals.fatigueRisk,
          barColor: AppTheme.primaryBlue,
          subtitle: "Normal range based on sleep & motion telemetry",
        ),
        ProgressRiskCard(
          title: "Fall Risk",
          valuePercent: vitals.fallRisk,
          barColor: AppTheme.successGreen,
          subtitle: "IMU gait stability verified on-device",
        ),
        ProgressRiskCard(
          title: "Air Quality Exposure",
          valuePercent: vitals.airQualityExposure,
          barColor: AppTheme.warningAmber,
          subtitle: "Cumulative particulate burden (PM2.5 exposure)",
        ),
      ],
    );
  }
}
