import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/personal_baseline.dart';
import '../../../data/edge_ai/baseline_evaluator.dart';
import '../../providers/app_state.dart';

class TodayInsightsView extends StatelessWidget {
  final AppState state;

  const TodayInsightsView({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final vitals = state.vitals;
    final baseline = state.baseline;
    final env = state.environment;
    final todaySos = state.sosEvents.where((e) {
      final now = DateTime.now();
      return e.timestamp.year == now.year && e.timestamp.month == now.month && e.timestamp.day == now.day;
    }).toList();

    final insightText = BaselineEvaluator.evaluateHeartRateInsight(vitals, baseline, env);

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Plain-language personalized insight card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.psychology_rounded, color: AppTheme.primaryBlue, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Edge-AI Daily Assessment",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryDarkBlue,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              baseline.lifestyle.displayName,
                              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        insightText,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Live HR vs Personalized Baseline Band
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Heart Rate vs. Baseline Band",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    Text(
                      "${vitals.heartRate} BPM",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Normal band for ${baseline.lifestyle.displayName}: ${baseline.restingHrMin}-${baseline.workingHrMax} BPM",
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 14),

                // Graphic representation of baseline band
                _buildBaselineBandBar(vitals.heartRate, baseline),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Resting: ${baseline.restingHrMin} bpm", style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    Text("Max Work: ${baseline.workingHrMax} bpm", style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                    Text("Critical: ${baseline.maxSafeHr} bpm", style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Activity & Hydration status
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.directions_walk_rounded,
                  title: "Activity Today",
                  value: "42 min",
                  subtitle: "Moderate exertion",
                  iconColor: AppTheme.warningAmber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricTile(
                  icon: Icons.water_drop_rounded,
                  title: "Hydration",
                  value: "${state.todayHydrationTotal} ml",
                  subtitle: "Target: ${state.dynamicHydrationGoal} ml",
                  iconColor: AppTheme.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Today's SOS Events
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today's SOS Events",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: todaySos.isEmpty ? AppTheme.surfaceSubtle : AppTheme.dangerLightRed,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${todaySos.length} Event(s)",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: todaySos.isEmpty ? AppTheme.textSecondary : AppTheme.dangerRed,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (todaySos.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      "No emergency triggers today. System operational.",
                      style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                    ),
                  )
                else
                  ...todaySos.map((e) => Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: e.isFalseAlarm ? AppTheme.surfaceSubtle : const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: e.isFalseAlarm ? AppTheme.border : AppTheme.dangerRed.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              e.isFalseAlarm ? Icons.cancel_outlined : Icons.emergency_rounded,
                              size: 18,
                              color: e.isFalseAlarm ? AppTheme.textSecondary : AppTheme.dangerRed,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.isFalseAlarm ? "Cancelled (False Alarm)" : "SOS Sent to Emergency Contacts",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: e.isFalseAlarm ? AppTheme.textPrimary : AppTheme.dangerDarkRed,
                                    ),
                                  ),
                                  Text(
                                    "${e.timestamp.hour}:${e.timestamp.minute.toString().padLeft(2, '0')} • ${e.vitalsSummary}",
                                    style: const TextStyle(fontSize: 10.5, color: AppTheme.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBaselineBandBar(int currentHr, PersonalBaseline baseline) {
    const minScale = 40.0;
    const maxScale = 190.0;
    final totalRange = maxScale - minScale;

    final double normalLeft = ((baseline.restingHrMin - minScale) / totalRange).clamp(0.0, 1.0);
    final double normalWidth = ((baseline.workingHrMax - baseline.restingHrMin) / totalRange).clamp(0.0, 1.0);
    final double markerPos = ((currentHr - minScale) / totalRange).clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final barWidth = constraints.maxWidth;
        return Column(
          children: [
            // Marker
            Align(
              alignment: Alignment((markerPos * 2) - 1, 0),
              child: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryBlue, size: 20),
            ),
            Stack(
              children: [
                // Background Track
                Container(
                  height: 12,
                  width: barWidth,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceSubtle,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                // Personalized Normal Band
                Positioned(
                  left: barWidth * normalLeft,
                  width: barWidth * normalWidth,
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}

