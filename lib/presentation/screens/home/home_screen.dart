import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/app_state.dart';
import 'vitals_tab_view.dart';
import 'environment_tab_view.dart';
import 'risk_tab_view.dart';
import 'quick_actions_card.dart';
import '../../widgets/privacy_processing_card.dart';
import '../../widgets/hydration_modal.dart';

class HomeScreen extends StatelessWidget {
  final AppState state;

  const HomeScreen({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: shield icon, "Health Companion", "Privacy-first • Edge AI", green "Offline Active" pill
              _buildHeader(),
              const SizedBox(height: 16),

              // Segmented Tab Switcher: Vitals | Environment | Risk
              _buildSegmentedTabSwitcher(context),
              const SizedBox(height: 16),

              // Tab Content Area: NEVER empty, always renders selected tab
              _buildTabContent(),

              // Quick Actions Card (wider, taller, no text wrapping)
              QuickActionsCard(
                onHydrationTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) => HydrationModal(state: state),
                  );
                },
                onActivityTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Activity session logged: +10 min moderate brisk walk"),
                      duration: Duration(seconds: 2),
                      backgroundColor: AppTheme.primaryDarkBlue,
                    ),
                  );
                },
              ),

              // Privacy-First Processing green card
              const PrivacyProcessingCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryLightBlue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: AppTheme.primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Health Companion",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Privacy-first • Edge AI",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        // Green "Offline Active" pill on right
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppTheme.successLightGreen,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.successGreen.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppTheme.successGreen,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "Offline Active",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.successGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedTabSwitcher(BuildContext context) {
    final tabs = ["Vitals", "Environment", "Risk"];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = state.homeTabIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => state.setHomeTabIndex(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  tabs[index],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (state.homeTabIndex) {
      case 1:
        return EnvironmentTabView(environment: state.environment);
      case 2:
        return RiskTabView(
          vitals: state.vitals,
          environment: state.environment,
          profile: state.profile,
          waterLoggedToday: state.todayHydrationTotal,
        );
      case 0:
      default:
        return VitalsTabView(vitals: state.vitals);
    }
  }
}

