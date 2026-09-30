import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ProgressRiskCard extends StatelessWidget {
  final String title;
  final double valuePercent; // 0 to 100
  final Color barColor;
  final String? subtitle;

  const ProgressRiskCard({
    super.key,
    required this.title,
    required this.valuePercent,
    required this.barColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              Text(
                "${valuePercent.toStringAsFixed(0)}%",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (valuePercent / 100.0).clamp(0.0, 1.0),
              minHeight: 7,
              backgroundColor: AppTheme.surfaceSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
          if (subtitle != null && subtitle!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
