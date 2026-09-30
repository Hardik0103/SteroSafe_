import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/environment_data.dart';
import '../../widgets/metric_card.dart';

class EnvironmentTabView extends StatelessWidget {
  final EnvironmentData environment;

  const EnvironmentTabView({
    super.key,
    required this.environment,
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
                title: "Ambient Temp",
                value: environment.ambientTemp.toStringAsFixed(1),
                unit: "°C",
                statusText: environment.tempStatus,
                statusColor: environment.ambientTemp > 38.0
                    ? AppTheme.dangerRed
                    : (environment.ambientTemp > 32.0 ? AppTheme.warningAmber : AppTheme.successGreen),
                icon: Icons.wb_sunny_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                title: "Humidity",
                value: environment.humidity.toStringAsFixed(0),
                unit: "%",
                statusText: environment.humidityStatus,
                statusColor: environment.humidity > 70 ? AppTheme.warningAmber : AppTheme.successGreen,
                icon: Icons.water_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: MetricCard(
                title: "AQI",
                value: "${environment.aqi}",
                unit: "",
                statusText: environment.aqiStatus,
                statusColor: environment.aqi > 200 ? AppTheme.dangerRed : AppTheme.warningAmber,
                icon: Icons.cloud_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: MetricCard(
                title: "Heat Index",
                value: environment.heatIndex.toStringAsFixed(1),
                unit: "°C",
                statusText: environment.heatIndexStatus,
                statusColor: environment.heatIndex >= 41.0 ? AppTheme.dangerRed : AppTheme.warningAmber,
                icon: Icons.whatshot_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Environment Guidance card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.lightbulb_outline_rounded, size: 20, color: AppTheme.primaryBlue),
                  SizedBox(width: 8),
                  Text(
                    "Environment Guidance",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildGuidanceItem(
                Icons.ac_unit_rounded,
                "Move to a cooler area",
                "Ambient heat index is high (${environment.heatIndex.toStringAsFixed(1)}°C). Seek ventilated shade or air-conditioned shelter.",
                AppTheme.primaryBlue,
              ),
              const Divider(height: 18, color: AppTheme.surfaceSubtle),
              _buildGuidanceItem(
                Icons.water_drop_rounded,
                "Maintain hydration",
                "Drink 250-300 ml fluids every 30 minutes. Use ORS or lemon water to retain salts.",
                AppTheme.accentCyan,
              ),
              const Divider(height: 18, color: AppTheme.surfaceSubtle),
              _buildGuidanceItem(
                Icons.masks_rounded,
                "Reduce pollution exposure",
                "AQI is ${environment.aqi} (Unhealthy). Minimize heavy outdoor physical exertion.",
                AppTheme.warningAmber,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGuidanceItem(IconData icon, String title, String desc, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

