import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/alert_item.dart';
import '../../providers/app_state.dart';

class AlertsScreen extends StatelessWidget {
  final AppState state;

  const AlertsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final alerts = state.alerts;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          "Disaster & Health Alerts",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.successLightGreen,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              "Local Edge AI",
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.successGreen),
            ),
          ),
        ],
      ),
      body: alerts.isEmpty
          ? const Center(
              child: Text(
                "No active alerts in your sector.",
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return _buildAlertCard(context, alert);
              },
            ),
    );
  }

  Widget _buildAlertCard(BuildContext context, AlertItem alert) {
    // Specific Requirement: HIGH Heat Exposure alert card is visually RED throughout
    final bool isHighHeat = alert.isHighHeatAlert;

    // Background, border, icon, and text styling
    final Color cardBg = isHighHeat
        ? const Color(0xFFFEE2E2) // Light red warning background
        : (alert.severity == AlertSeverity.medium
            ? const Color(0xFFFFFBEB)
            : AppTheme.surface);

    final Color borderColor = isHighHeat
        ? const Color(0xFFEF4444) // Red border
        : (alert.severity == AlertSeverity.medium
            ? const Color(0xFFFDE68A)
            : AppTheme.border);

    final Color iconBg = isHighHeat
        ? const Color(0xFFFCA5A5)
        : (alert.severity == AlertSeverity.medium
            ? const Color(0xFFFEF3C7)
            : AppTheme.surfaceSubtle);

    final Color iconColor = isHighHeat
        ? const Color(0xFF991B1B)
        : (alert.severity == AlertSeverity.medium
            ? AppTheme.warningAmber
            : AppTheme.primaryBlue);

    final Color titleColor = isHighHeat ? const Color(0xFF991B1B) : AppTheme.textPrimary;
    final Color descColor = isHighHeat ? const Color(0xFF7F1D1D) : AppTheme.textSecondary;
    final Color badgeBg = isHighHeat ? const Color(0xFFDC2626) : (alert.severity == AlertSeverity.medium ? AppTheme.warningAmber : AppTheme.primaryBlue);
    final Color badgeTextColor = Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: isHighHeat ? 1.5 : 1.0),
        boxShadow: [
          BoxShadow(
            color: isHighHeat ? const Color(0xFFEF4444).withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.02),
            blurRadius: isHighHeat ? 8 : 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  alert.type == AlertType.heat
                      ? Icons.whatshot_rounded
                      : (alert.type == AlertType.airQuality ? Icons.air_rounded : Icons.water_damage_rounded),
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            alert.title,
                            style: TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                        ),
                        // Severity badge (HIGH)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: badgeBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            alert.severity.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: badgeTextColor,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      alert.description,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: descColor,
                        height: 1.35,
                        fontWeight: isHighHeat ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (alert.advice != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isHighHeat ? const Color(0xFFFEE2E2).withValues(alpha: 0.8) : AppTheme.surfaceSubtle,
                borderRadius: BorderRadius.circular(8),
                border: isHighHeat ? Border.all(color: const Color(0xFFF87171).withValues(alpha: 0.5)) : null,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 14,
                    color: isHighHeat ? const Color(0xFF991B1B) : AppTheme.primaryBlue,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      alert.advice!,
                      style: TextStyle(
                        fontSize: 11,
                        color: isHighHeat ? const Color(0xFF7F1D1D) : AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

