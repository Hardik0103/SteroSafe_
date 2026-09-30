import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/ppg_waveform_painter.dart';

class PpgTelemetryCard extends StatelessWidget {
  final List<double> ppgBuffer;
  final bool isSimulated;

  const PpgTelemetryCard({
    super.key,
    required this.ppgBuffer,
    this.isSimulated = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14, bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.show_chart_rounded, size: 18, color: AppTheme.primaryBlue),
                  SizedBox(width: 8),
                  Text(
                    "PPG Telemetry",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.successLightGreen,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.3), width: 1),
                ),
                child: Text(
                  isSimulated ? "SIMULATED" : "HARDWARE LIVE",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.successGreen,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 90,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border.withValues(alpha: 0.5)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: PpgWaveformPainter(
                  points: ppgBuffer.isNotEmpty
                      ? ppgBuffer
                      : List.generate(30, (i) => 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Sampling: 50 Hz Qualcomm Sensor Hub",
                style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
              ),
              Text(
                "Buffer: 3.2s window",
                style: TextStyle(fontSize: 10, color: AppTheme.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

