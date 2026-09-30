import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PrivacyProcessingCard extends StatelessWidget {
  const PrivacyProcessingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.successLightGreen.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.successGreen.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 20,
            color: AppTheme.successGreen,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Privacy-first processing",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF065F46),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "All physiological & environmental models run 100% on-device. Zero telemetry leaves this Qualcomm edge unit.",
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF047857),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

