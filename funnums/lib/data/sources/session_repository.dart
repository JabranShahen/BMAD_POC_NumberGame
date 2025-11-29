import '../../core/services/storage_service.dart';
import '../models/session_stats.dart';
import '../models/settings.dart';

/// Stub persistence for session stats/history.
/// TODO: Wire to StorageService with Hive/JSON and versioning.
class SessionRepository {
  SessionRepository(this._storage);

  final StorageService _storage;
  static const _bestKey = 'best_scores';
  static const _lastKey = 'last_scores';

  Future<void> initialize() async {
    await _storage.initialize();
  }

  Future<SessionStats> load(String mode) async {
    final bests = await loadBestScores();
    return SessionStats(
      mode: mode,
      score: 0,
      bestPerMode: bests,
      solvedCounts: {mode: 0},
      history: const [],
    );
  }

  Future<Map<String, int>> loadBestScores() async {
    final data = await _storage.readValue<dynamic>(_bestKey);
    if (data is Map) {
      return {
        'fun': (data['fun'] as num?)?.toInt() ?? 0,
        'medium': (data['medium'] as num?)?.toInt() ?? 0,
        'hard': (data['hard'] as num?)?.toInt() ?? 0,
      };
    }
    return {'fun': 0, 'medium': 0, 'hard': 0};
  }

  Future<void> saveBestScore(String mode, int score) async {
    final bests = await loadBestScores();
    final current = bests[mode] ?? 0;
    if (score > current) {
      bests[mode] = score;
      await _storage.saveValue(_bestKey, bests);
    }
    await saveLastScore(mode, score);
  }

  Future<Map<String, int>> loadLastScores() async {
    final data = await _storage.readValue<dynamic>(_lastKey);
    if (data is Map) {
      return {
        'fun': (data['fun'] as num?)?.toInt() ?? 0,
        'medium': (data['medium'] as num?)?.toInt() ?? 0,
        'hard': (data['hard'] as num?)?.toInt() ?? 0,
      };
    }
    return {'fun': 0, 'medium': 0, 'hard': 0};
  }

  Future<void> saveLastScore(String mode, int score) async {
    final last = await loadLastScores();
    last[mode] = score;
    await _storage.saveValue(_lastKey, last);
  }

  Future<void> save(SessionStats stats) async {
    await saveBestScore(stats.mode, stats.score);
    // TODO: Persist full stats/history.
  }
}

class SettingsRepository {
  SettingsRepository(this._storage);
  final StorageService _storage;
  static const _settingsKey = 'app_settings';
  Future<void> initialize() async {
    await _storage.initialize();
  }

  Future<AppSettings> load() async {
    final data = await _storage.readValue<Map<String, dynamic>>(_settingsKey);
    if (data != null) {
      return AppSettings(
        soundEnabled: data['soundEnabled'] as bool? ?? true,
        hapticsEnabled: data['hapticsEnabled'] as bool? ?? true,
        version: data['version'] as int? ?? 1,
      );
    }
    return const AppSettings(soundEnabled: true, hapticsEnabled: true, version: 1);
  }

  Future<void> save(AppSettings settings) async {
    await _storage.saveValue(_settingsKey, {
      'soundEnabled': settings.soundEnabled,
      'hapticsEnabled': settings.hapticsEnabled,
      'version': settings.version,
    });
  }
}
