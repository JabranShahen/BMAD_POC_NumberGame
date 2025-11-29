import '../core/services/ads_service.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/puzzle_service.dart';
import '../core/services/storage_service.dart';

class Services {
  Services._();

  static final ads = AdsService();
  static final storage = StorageService();
  static final puzzles = PuzzleService();
  static final connectivity = ConnectivityService();

  /// Initialize shared services at app startup.
  static Future<void> init() async {
    await storage.initialize();
    await puzzles.loadPools();
    await ads.initialize();
  }
}
