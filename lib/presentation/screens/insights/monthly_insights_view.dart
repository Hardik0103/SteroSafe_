import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/app_state.dart';

class MonthlyInsightsView extends StatefulWidget {
  final AppState state;

  const MonthlyInsightsView({super.key, required this.state});

  @override
  State<MonthlyInsightsView> createState() => _MonthlyInsightsViewState();
}

class _MonthlyInsightsViewState extends State<MonthlyInsightsView> {
  int _monthOffset = 0; // 0 = September 2026, -1 = August 2026
  int? _selectedDay;

  // Day colors: green = low risk, yellow = medium, red = high
  // Days 1..30 for September
  Color _getDayColor(int day) {
    if (day == 8 || day == 16 || day == 23) {
      return AppTheme.dangerRed; // High heat wave days
    } else if (day == 5 || day == 12 || day == 19 || day == 27) {
      return AppTheme.warningAmber; // Moderate risk
    }
    return AppTheme.successGreen; // Safe baseline days
  }

  bool _hasSosMarker(int day) {
    return day == 16 || day == 23 || day == 30;
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _monthOffset == 0 ? "September 2026" : "August 2026";
    final totalDays = _monthOffset == 0 ? 30 : 31;
    final baseline = widget.state.baseline;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month Navigator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left_rounded),
                onPressed: () => setState(() => _monthOffset--),
              ),
              Text(
                monthName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right_rounded),
                onPressed: _monthOffset < 0 ? () => setState(() => _monthOffset++) : null,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Monthly Metrics Overview
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryStat("Avg HR", "75 BPM", "Normal"),
                _buildSummaryStat("Avg Hydration", "2,480 ml", "98% goal"),
                _buildSummaryStat("Alerts", "6", "3 Heat, 3 AQI"),
                _buildSummaryStat("SOS Events", "2", "False alarms"),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Calendar Grid Card
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Risk & Incident Heatmap",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    Row(
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: AppTheme.successGreen),
                        SizedBox(width: 4),
                        Text("Low", style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                        SizedBox(width: 6),
                        CircleAvatar(radius: 4, backgroundColor: AppTheme.warningAmber),
                        SizedBox(width: 4),
                        Text("Med", style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                        SizedBox(width: 6),
                        CircleAvatar(radius: 4, backgroundColor: AppTheme.dangerRed),
                        SizedBox(width: 4),
                        Text("High", style: TextStyle(fontSize: 10, color: AppTheme.textMuted)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Weekday initials
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const ["M", "T", "W", "T", "F", "S", "S"].map((d) {
                    return SizedBox(
                      width: 32,
                      child: Text(
                        d,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.textMuted),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),

                // Days grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: totalDays,
                  itemBuilder: (context, idx) {
                    final day = idx + 1;
                    final color = _getDayColor(day);
                    final hasSos = _hasSosMarker(day);
                    final isSelected = _selectedDay == day;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedDay = day),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.primaryLightBlue : AppTheme.surfaceSubtle,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? AppTheme.primaryBlue : color.withValues(alpha: 0.5),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              "$day",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppTheme.primaryBlue : AppTheme.textPrimary,
                              ),
                            ),
                            Positioned(
                              bottom: 3,
                              child: Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                            if (hasSos)
                              const Positioned(
                                top: 2,
                                right: 2,
                                child: Icon(Icons.circle, color: AppTheme.dangerRed, size: 5),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Day drilldown report if day is tapped
          if (_selectedDay != null)
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
                        "Report for Sep $_selectedDay, 2026",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => setState(() => _selectedDay = null),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Average Heart Rate: 76 BPM (Norm band: ${baseline.restingHrMin}-${baseline.workingHrMax} BPM). Hydration logged: 2,650 ml. No cardiac anomalies detected.",
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3),
                  ),
                  if (_hasSosMarker(_selectedDay!))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        "⚠️ 1 Emergency alarm logged on this date (Aborted by user before dispatch timeout).",
                        style: const TextStyle(fontSize: 11, color: AppTheme.dangerRed, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String title, String value, String sub) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
        const SizedBox(height: 2),
        Text(sub, style: const TextStyle(fontSize: 9.5, color: AppTheme.textMuted)),
      ],
    );
  }
}

