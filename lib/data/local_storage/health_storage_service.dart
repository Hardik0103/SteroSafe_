import '../../domain/models/hydration_entry.dart';
import '../../domain/models/user_profile.dart';

class HealthStorageService {
  UserProfile _cachedProfile = UserProfile.defaultProfile();
  final List<HydrationEntry> _hydrationHistory = [];

  HealthStorageService() {
    // Pre-populate with realistic today's hydration history
    final now = DateTime.now();
    _hydrationHistory.addAll([
      HydrationEntry(
        id: "hyd-1",
        timestamp: DateTime(now.year, now.month, now.day, 8, 30),
        amountMl: 350,
      ),
      HydrationEntry(
        id: "hyd-2",
        timestamp: DateTime(now.year, now.month, now.day, 11, 15),
        amountMl: 250,
      ),
      HydrationEntry(
        id: "hyd-3",
        timestamp: DateTime(now.year, now.month, now.day, 13, 40),
        amountMl: 500,
      ),
    ]);
  }

  UserProfile getProfile() => _cachedProfile;

  void saveProfile(UserProfile profile) {
    _cachedProfile = profile;
  }

  List<HydrationEntry> getHydrationEntries() => List.unmodifiable(_hydrationHistory);

  void addHydrationEntry(int amountMl) {
    final entry = HydrationEntry(
      id: "hyd-${DateTime.now().millisecondsSinceEpoch}",
      timestamp: DateTime.now(),
      amountMl: amountMl,
    );
    _hydrationHistory.insert(0, entry);
  }

  void removeHydrationEntry(String id) {
    _hydrationHistory.removeWhere((entry) => entry.id == id);
  }

  int getTodayHydrationTotal() {
    final now = DateTime.now();
    return _hydrationHistory
        .where((e) => e.timestamp.year == now.year && e.timestamp.month == now.month && e.timestamp.day == now.day)
        .fold(0, (sum, e) => sum + e.amountMl);
  }
}
