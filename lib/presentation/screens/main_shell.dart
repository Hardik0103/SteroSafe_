import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_state.dart';
import '../widgets/sos_countdown_overlay.dart';
import 'home/home_screen.dart';
import 'alerts/alerts_screen.dart';
import 'insights/insights_screen.dart';
import 'profile/profile_screen.dart';

class MainShell extends StatelessWidget {
  final AppState state;

  const MainShell({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Stack(
          children: [
            Scaffold(
              body: _buildCurrentScreen(),
              bottomNavigationBar: _buildBottomNav(context),
            ),
            // Full screen 15-second SOS Countdown Overlay
            SosCountdownOverlay(state: state),
          ],
        );
      },
    );
  }

  Widget _buildCurrentScreen() {
    switch (state.bottomNavIndex) {
      case 1:
        return AlertsScreen(state: state);
      case 2:
        return InsightsScreen(state: state);
      case 3:
        return ProfileScreen(state: state);
      case 0:
      default:
        return HomeScreen(state: state);
    }
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: const Border(top: BorderSide(color: AppTheme.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 68,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // 0: Home
              _buildNavItem(
                icon: Icons.home_rounded,
                label: "Home",
                index: 0,
                isSelected: state.bottomNavIndex == 0,
              ),

              // 1: Alerts
              _buildNavItem(
                icon: Icons.notifications_rounded,
                label: "Alerts",
                index: 1,
                isSelected: state.bottomNavIndex == 1,
                badgeCount: state.alerts.length,
              ),

              // Center Raised Red SOS Button
              GestureDetector(
                onTap: () => state.startSosCountdown(),
                child: Container(
                  transform: Matrix4.translationValues(0, -10, 0),
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppTheme.dangerRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.dangerRed.withValues(alpha: 0.4),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Center(
                    child: Text(
                      "SOS",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),

              // 2: Insights
              _buildNavItem(
                icon: Icons.insights_rounded,
                label: "Insights",
                index: 2,
                isSelected: state.bottomNavIndex == 2,
              ),

              // 3: Health / Profile
              _buildNavItem(
                icon: Icons.person_rounded,
                label: "Health",
                index: 3,
                isSelected: state.bottomNavIndex == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    int? badgeCount,
  }) {
    final color = isSelected ? AppTheme.primaryBlue : AppTheme.textMuted;

    return InkWell(
      onTap: () => state.setBottomNavIndex(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, size: 22, color: color),
                if (badgeCount != null && badgeCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: AppTheme.dangerRed,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        "$badgeCount",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 8.5, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

