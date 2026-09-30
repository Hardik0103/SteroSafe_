import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../providers/app_state.dart';

class SosCountdownOverlay extends StatelessWidget {
  final AppState state;

  const SosCountdownOverlay({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (!state.isSosCountdownActive && !state.lastSosSentConfirmed) {
      return const SizedBox.shrink();
    }

    // Confirmation screen if SOS was dispatched
    if (state.lastSosSentConfirmed) {
      return Container(
        color: Colors.black87,
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.dangerLightRed,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.dangerRed,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "SOS Sent",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Emergency broadcast dispatched offline to contacts and Dr. ${state.profile.doctorName}.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceSubtle,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Patient: ${state.profile.fullName}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      Text("Vitals: HR ${state.vitals.heartRate} bpm, SpO2 ${state.vitals.spo2.toStringAsFixed(1)}%", style: const TextStyle(fontSize: 11)),
                      Text("Location: Lat 28.6139° N, Lon 77.2090° E", style: const TextStyle(fontSize: 11)),
                      Text("Conditions: ${state.profile.healthConditions.join(', ')}", style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => state.dismissSosConfirmation(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Dismiss Confirmation"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Active 15-second countdown overlay
    return Container(
      color: Colors.black.withValues(alpha: 0.88),
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top warning banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.dangerRed.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.dangerRed),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, color: AppTheme.dangerRed, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "EMERGENCY PROTOCOL ACTIVATED",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            // Pulsing countdown ring
            Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 180,
                      height: 180,
                      child: CircularProgressIndicator(
                        value: state.sosCountdownSeconds / 15.0,
                        strokeWidth: 12,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.dangerRed),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${state.sosCountdownSeconds}",
                          style: const TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "SECONDS",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  "Sending alert to emergency contacts & doctor",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "[Simulated beep / haptic pulse active]",
                  style: TextStyle(fontSize: 12, color: Colors.white54),
                ),
              ],
            ),

            // Cancel Button
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      state.cancelSosCountdown();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Emergency cancelled. Logged as false alarm."),
                          backgroundColor: AppTheme.textPrimary,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.dangerRed,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "CANCEL SOS",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Tap cancel to abort and log false alarm",
                  style: TextStyle(fontSize: 11, color: Colors.white54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

