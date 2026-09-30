import 'dart:async';
import 'package:flutter/material.dart';
import '../../domain/models/vitals_data.dart';
import '../../domain/models/environment_data.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/personal_baseline.dart';
import '../../domain/models/alert_item.dart';
import '../../domain/models/hydration_entry.dart';
import '../../domain/models/sos_event.dart';
import '../../domain/repositories/vitals_repository.dart';
import '../../domain/repositories/environment_repository.dart';
import '../../domain/repositories/sos_repository.dart';
import '../../data/local_storage/health_storage_service.dart';

class AppState extends ChangeNotifier {
  final VitalsRepository vitalsRepo;
  final EnvironmentRepository environmentRepo;
  final SosRepository sosRepo;
  final HealthStorageService storageService;

  // Streams subscriptions
  StreamSubscription<VitalsData>? _vitalsSub;
  StreamSubscription<EnvironmentData>? _envSub;
  StreamSubscription<List<AlertItem>>? _alertsSub;
  StreamSubscription<List<SosEvent>>? _sosSub;

  // State fields
  VitalsData _vitals = VitalsData.fallbackDefault();
  EnvironmentData _environment = EnvironmentData.defaultEnvironment();
  List<AlertItem> _alerts = [];
  List<SosEvent> _sosEvents = [];
  late UserProfile _profile;

  // Home Screen Segmented Tab: 0 = Vitals, 1 = Environment, 2 = Risk
  int _homeTabIndex = 0;

  // Bottom Navigation: 0 = Home, 1 = Alerts, 2 = Insights, 3 = Health
  int _bottomNavIndex = 0;

  // Insights View Selection: "Today", "Weekly", "Monthly"
  String _insightsSelectedTab = "Today";

  // SOS Countdown state
  bool _isSosCountdownActive = false;
  int _sosCountdownSeconds = 15;
  Timer? _sosTimer;
  bool _lastSosSentConfirmed = false;
  String _lastDispatchedSummary = "";

  AppState({
    required this.vitalsRepo,
    required this.environmentRepo,
    required this.sosRepo,
    required this.storageService,
  }) {
    _profile = storageService.getProfile();
    _alerts = environmentRepo.currentAlerts;
    _sosEvents = sosRepo.historicalEvents;

    _initListeners();
  }

  void _initListeners() {
    _vitalsSub = vitalsRepo.vitalsStream.listen((data) {
      _vitals = data;
      notifyListeners();
    });

    _envSub = environmentRepo.environmentStream.listen((data) {
      _environment = data;
      notifyListeners();
    });

    _alertsSub = environmentRepo.disasterAlertsStream.listen((data) {
      _alerts = data;
      notifyListeners();
    });

    _sosSub = sosRepo.sosEventsStream.listen((data) {
      _sosEvents = data;
      notifyListeners();
    });
  }

  // Getters
  VitalsData get vitals => _vitals;
  EnvironmentData get environment => _environment;
  List<AlertItem> get alerts => _alerts;
  List<SosEvent> get sosEvents => _sosEvents;
  UserProfile get profile => _profile;
  int get homeTabIndex => _homeTabIndex;
  int get bottomNavIndex => _bottomNavIndex;
  String get insightsSelectedTab => _insightsSelectedTab;
  bool get isSosCountdownActive => _isSosCountdownActive;
  int get sosCountdownSeconds => _sosCountdownSeconds;
  bool get lastSosSentConfirmed => _lastSosSentConfirmed;
  String get lastDispatchedSummary => _lastDispatchedSummary;

  PersonalBaseline get baseline => PersonalBaseline.forLifestyle(_profile.lifestyle, age: _profile.age);

  List<HydrationEntry> get hydrationEntries => storageService.getHydrationEntries();
  int get todayHydrationTotal => storageService.getTodayHydrationTotal();

  /// Daily goal dynamically adjusted for heat index and user occupation
  int get dynamicHydrationGoal {
    int base = _profile.dailyHydrationGoalMl;
    if (_environment.heatIndex >= 40.0) {
      base += 600;
    } else if (_environment.heatIndex >= 35.0) {
      base += 350;
    }
    if (_profile.lifestyle == LifestyleType.construction) {
      base += 500;
    }
    return base;
  }

  // Tab & Navigation setters
  void setHomeTabIndex(int index) {
    if (index >= 0 && index <= 2) {
      _homeTabIndex = index;
      notifyListeners();
    }
  }

  void setBottomNavIndex(int index) {
    if (index >= 0 && index <= 3) {
      _bottomNavIndex = index;
      // When user opens Insights afresh, defaults to Today
      if (index == 2 && _bottomNavIndex != 2) {
        _insightsSelectedTab = "Today";
      }
      notifyListeners();
    }
  }

  void setInsightsSelectedTab(String tab) {
    _insightsSelectedTab = tab;
    notifyListeners();
  }

  // Profile operations
  void updateProfile(UserProfile updated) {
    _profile = updated;
    storageService.saveProfile(updated);
    notifyListeners();
  }

  // Hydration operations
  void addWater(int amountMl) {
    storageService.addHydrationEntry(amountMl);
    notifyListeners();
  }

  void removeWater(String id) {
    storageService.removeHydrationEntry(id);
    notifyListeners();
  }

  // SOS Operations
  void startSosCountdown() {
    _lastSosSentConfirmed = false;
    _isSosCountdownActive = true;
    _sosCountdownSeconds = 15;
    notifyListeners();

    _sosTimer?.cancel();
    _sosTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sosCountdownSeconds > 1) {
        _sosCountdownSeconds--;
        notifyListeners();
      } else {
        _sosCountdownSeconds = 0;
        timer.cancel();
        _triggerAutoEmergencyDispatch();
      }
    });
  }

  void cancelSosCountdown() {
    _sosTimer?.cancel();
    _isSosCountdownActive = false;
    sosRepo.logCancelledSos("Lat: 28.6139° N, Lon: 77.2090° E (New Delhi)", _vitals);
    notifyListeners();
  }

  Future<void> _triggerAutoEmergencyDispatch() async {
    _isSosCountdownActive = false;
    _lastSosSentConfirmed = true;
    final event = await sosRepo.dispatchEmergency(
      profile: _profile,
      vitals: _vitals,
      location: "Lat: 28.6139° N, Lon: 77.2090° E (Qualcomm Campus, Delhi NCR)",
    );
    _lastDispatchedSummary = event.note;
    notifyListeners();
  }

  void dismissSosConfirmation() {
    _lastSosSentConfirmed = false;
    notifyListeners();
  }

  // Simulation / hardware packet test
  void injectHardwareTelemetryPacket(List<int> packet, int crc) {
    vitalsRepo.ingestHardwarePacket(packet, crc);
  }

  @override
  void dispose() {
    _vitalsSub?.cancel();
    _envSub?.cancel();
    _alertsSub?.cancel();
    _sosSub?.cancel();
    _sosTimer?.cancel();
    super.dispose();
  }
}
