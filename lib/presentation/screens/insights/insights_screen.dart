import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/app_state.dart';
import 'today_insights_view.dart';
import 'weekly_insights_view.dart';
import 'monthly_insights_view.dart';

class InsightsScreen extends StatelessWidget {
  final AppState state;

  const InsightsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text(
          "Personalized Insights",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: ["Today", "Weekly", "Monthly"].map((tab) {
                final isSelected = state.insightsSelectedTab == tab;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => state.setInsightsSelectedTab(tab),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tab,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                          color: isSelected ? Colors.white : AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildSelectedView(),
      ),
    );
  }

  Widget _buildSelectedView() {
    switch (state.insightsSelectedTab) {
      case "Weekly":
        return WeeklyInsightsView(state: state);
      case "Monthly":
        return MonthlyInsightsView(state: state);
      case "Today":
      default:
        return TodayInsightsView(state: state);
    }
  }
}

