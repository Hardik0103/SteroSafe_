class DisasterThresholds {
  // Indian Meteorological Department (IMD) Heat Wave criteria
  static const double heatWaveWarningTempC = 40.0;
  static const double extremeHeatTempC = 45.0;
  static const double highHeatIndexC = 41.0;
  static const double dangerHeatIndexC = 54.0;

  // Wet Bulb Globe Temperature (WBGT) thresholds
  static const double wbgtCautionC = 28.0;
  static const double wbgtExtremeC = 32.0;

  // National AQI (India) Breakpoints
  static const int aqiModerate = 100;
  static const int aqiPoor = 200;
  static const int aqiVeryPoor = 300;
  static const int aqiSevere = 400;

  // Physiological thresholds
  static const double normalBodyTempMinC = 36.1;
  static const double normalBodyTempMaxC = 37.2;
  static const double feverBodyTempC = 38.0;
  static const double heatStrokeBodyTempC = 40.0;

  static const double normalSpo2Min = 95.0;
  static const double criticalSpo2Min = 90.0;

  static const int normalRespRateMin = 12;
  static const int normalRespRateMax = 20;

  // Fall detection jerk acceleration threshold (m/s^3 or G-units)
  static const double fallJerkThresholdG = 2.8;
  static const int fallInactivityWindowSec = 6;
}
