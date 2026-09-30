import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/models/personal_baseline.dart';
import '../../providers/app_state.dart';

class WeeklyInsightsView extends StatefulWidget {
  final AppState state;

  const WeeklyInsightsView({super.key, required this.state});

  @override
  State<WeeklyInsightsView> createState() => _WeeklyInsightsViewState();
}

class _WeeklyInsightsViewState extends State<WeeklyInsightsView> {
  int _selectedDayIndex = 2; // Wednesday by default
  int _weekOffset = 0; // 0 = current week, -1 = last week

  final List<String> _days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  // Mocked weekly data for demonstration
  final List<Map<String, dynamic>> _weekData = [
    {"avgHr": 74, "waterMl": 2400, "activityMin": 45, "fatigue": 22.0, "risk": "Low", "sosCount": 0},
    {"avgHr": 79, "waterMl": 2100, "activityMin": 50, "fatigue": 35.0, "risk": "Medium", "sosCount": 0},
    {"avgHr": 82, "waterMl": 2600, "activityMin": 60, "fatigue": 40.0, "risk": "Elevated", "sosCount": 1},
    {"avgHr": 76, "waterMl": 2800, "activityMin": 30, "fatigue": 25.0, "risk": "Low", "sosCount": 0},
    {"avgHr": 78, "waterMl": 2300, "activityMin": 40, "fatigue": 30.0, "risk": "Low", "sosCount": 0},
    {"avgHr": 72, "waterMl": 2900, "activityMin": 75, "fatigue": 18.0, "risk": "Low", "sosCount": 0},
    {"avgHr": 70, "waterMl": 2500, "activityMin": 20, "fatigue": 15.0, "risk": "Low", "sosCount": 0},
  ];

  @override
  Widget build(BuildContext context) {
    final baseline = widget.state.baseline;
    final dayReport = _weekOffset == 0 ? _weekData[_selectedDayIndex] : null;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Week Navigator (Prev / Next)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: () => setState(() => _weekOffset--),
              ),
              Text(
                _weekOffset == 0 ? "This Week (Sep 28 - Oct 4)" : "Previous Week",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: _weekOffset < 0 ? () => setState(() => _weekOffset++) : null,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Mon - Sun Day Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_days.length, (idx) {
              final isSelected = _selectedDayIndex == idx;
              return GestureDetector(
                onTap: () => setState(() => _selectedDayIndex = idx),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlue : AppTheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? AppTheme.primaryBlue : AppTheme.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _days[idx],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${28 + idx}",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),

          // Selected Day Report or Empty State
          if (dayReport == null)
            Container(
              padding: const EdgeInsets.all(32),
              alignment: Alignment.center,
              child: const Text("No recorded telemetry for this archive week.", style: TextStyle(color: AppTheme.textMuted)),
            )
          else ...[
            // Daily detailed report card
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
                      Text(
                        "${_days[_selectedDayIndex]} Summary",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: dayReport["risk"] == "Elevated" ? AppTheme.dangerLightRed : AppTheme.successLightGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "Risk: ${dayReport["risk"]}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: dayReport["risk"] == "Elevated" ? AppTheme.dangerRed : AppTheme.successGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildRowItem("Average Heart Rate", "${dayReport["avgHr"]} BPM", "Baseline Band: ${baseline.restingHrMin}-${baseline.workingHrMax} BPM"),
                  const Divider(height: 16),
                  _buildRowItem("Hydration Total", "${dayReport["waterMl"]} ml", "Daily Goal: ${widget.state.dynamicHydrationGoal} ml"),
                  const Divider(height: 16),
                  _buildRowItem("Active Exertion", "${dayReport["activityMin"]} min", "Target met"),
                  const Divider(height: 16),
                  _buildRowItem("Fatigue Score", "${dayReport["fatigue"]}%", "Physiological recovery adequate"),
                  if (dayReport["sosCount"] > 0) ...[
                    const Divider(height: 16),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.emergency_rounded, size: 16, color: AppTheme.dangerRed),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "1 SOS Event (False alarm cancelled within 15s window)",
                              style: TextStyle(fontSize: 11, color: AppTheme.dangerDarkRed, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Weekly Summary & Suggestions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.insights_rounded, color: AppTheme.successGreen, size: 20),
                      SizedBox(width: 8),
                      Text("Weekly Edge Suggestion", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your average heart rate of ${dayReport["avgHr"]} BPM is strictly compliant with ${baseline.lifestyle.displayName} norms. On Wednesday, high heat index triggered elevated cardiac load. Keep carrying oral rehydration salts.",
                    style: const TextStyle(fontSize: 12, color: Color(0xFF14532D), height: 1.35),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRowItem(String label, String value, String sub) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            const SizedBox(height: 2),
            Text(sub, style: const TextStyle(fontSize: 10, color: AppTheme.textMuted)),
          ],
        ),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
      ],
    );
  }
}

