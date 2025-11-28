import '../models/puzzle.dart';

/// Represents a complete game session
class GameSession {
  final String id;
  final List<PuzzleAttempt> attempts;
  final DateTime startedAt;
  final GameSessionState state;
  final Duration? totalDuration;

  GameSession({
    required this.id,
    required this.attempts,
    required this.state,
    DateTime? startedAt,
    this.totalDuration,
  }) : startedAt = startedAt ?? DateTime.now();

  /// Current score based on correct answers and speed
  double get score => attempts.fold(0.0, (sum, attempt) => sum + attempt.score);

  /// Number of correct answers
  int get correctCount => attempts.where((a) => a.isCorrect).length;

  /// Accuracy percentage
  double get accuracy => attempts.isEmpty ? 0.0 : (correctCount / attempts.length) * 100;

  /// Average time per puzzle
  Duration get averageTime {
    if (attempts.isEmpty) return Duration.zero;
    final totalMs = attempts.fold<int>(0, (sum, a) => sum + a.timeTaken.inMilliseconds);
    return Duration(milliseconds: totalMs ~/ attempts.length);
  }

  /// Current streak of correct answers
  int get currentStreak {
    int streak = 0;
    for (final attempt in attempts.reversed) {
      if (attempt.isCorrect) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Creates a new session with an additional attempt
  GameSession addAttempt(PuzzleAttempt attempt) {
    return GameSession(
      id: id,
      attempts: [...attempts, attempt],
      state: state,
      startedAt: startedAt,
    );
  }

  /// Completes the session
  GameSession complete() {
    return GameSession(
      id: id,
      attempts: attempts,
      state: GameSessionState.completed,
      startedAt: startedAt,
      totalDuration: DateTime.now().difference(startedAt),
    );
  }
}

/// State of a game session
enum GameSessionState {
  active('Active'),
  paused('Paused'),
  completed('Completed'),
  abandoned('Abandoned');

  const GameSessionState(this.displayName);
  final String displayName;
}

/// Settings for the game
class GameSettings {
  final bool soundEnabled;
  final bool hapticsEnabled;
  final DifficultyLevel? forcedDifficulty;

  const GameSettings({
    this.soundEnabled = true,
    this.hapticsEnabled = true,
    this.forcedDifficulty,
  });

  GameSettings copyWith({
    bool? soundEnabled,
    bool? hapticsEnabled,
    DifficultyLevel? forcedDifficulty,
  }) {
    return GameSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      forcedDifficulty: forcedDifficulty ?? this.forcedDifficulty,
    );
  }
}