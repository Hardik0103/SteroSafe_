import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PpgWaveformPainter extends CustomPainter {
  final List<double> points;

  PpgWaveformPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // Draw subtle medical grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0).withValues(alpha: 0.6)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Draw Waveform glow
    final glowPaint = Paint()
      ..color = AppTheme.successGreen.withValues(alpha: 0.25)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw Waveform line
    final wavePaint = Paint()
      ..color = AppTheme.successGreen
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final stepX = size.width / (points.length - 1);

    for (int i = 0; i < points.length; i++) {
      final x = i * stepX;
      // Invert Y because canvas (0,0) is top-left
      final y = size.height - (points[i] * (size.height * 0.75) + (size.height * 0.12));
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant PpgWaveformPainter oldDelegate) => true;
}

