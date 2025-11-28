/// Domain entities for the game feature

/// Business logic representation of a puzzle
class PuzzleEntity {
  final List<int> sequence;
  final int missingIndex;
  final Difficulty difficulty;
  final List<int> options;

  const PuzzleEntity({
    required this.sequence,
    required this.missingIndex,
    required this.difficulty,
    required this.options,
  });

  /// The correct answer
  int get correctAnswer => sequence[missingIndex];

  /// Validates the puzzle structure
  bool get isValid =>
      sequence.isNotEmpty &&
      missingIndex >= 0 &&
      missingIndex < sequence.length &&
      options.contains(correctAnswer);

  /// Creates a copy with different options
  PuzzleEntity copyWithOptions(List<int> newOptions) {
    return PuzzleEntity(
      sequence: sequence,
      missingIndex: missingIndex,
      difficulty: difficulty,
      options: newOptions,
    );
  }
}

/// Difficulty levels with business logic parameters
enum Difficulty {
  easy(1, 'Easy', sequenceLength: 3, maxNumber: 20, timeLimitSeconds: 15),
  medium(2, 'Medium', sequenceLength: 4, maxNumber: 50, timeLimitSeconds: 12),
  hard(3, 'Hard', sequenceLength: 5, maxNumber: 100, timeLimitSeconds: 10);

  const Difficulty(
    this.level,
    this.displayName, {
    required this.sequenceLength,
    required this.maxNumber,
    required this.timeLimitSeconds,
  });

  final int level;
  final String displayName;
  final int sequenceLength;
  final int maxNumber;
  final int timeLimitSeconds;

  static Difficulty fromLevel(int level) {
    return Difficulty.values.firstWhere(
      (d) => d.level == level,
      orElse: () => Difficulty.medium,
    );
  }
}

/// Result of validating an answer
class ValidationResult {
  final bool isCorrect;
  final int correctAnswer;
  final Duration timeTaken;

  const ValidationResult({
    required this.isCorrect,
    required this.correctAnswer,
    required this.timeTaken,
  });

  /// Score calculation (0-100)
  double get score {
    if (!isCorrect) return 0.0;

    // Base score
    double baseScore = 50.0;

    // Time bonus (faster = higher score)
    final seconds = timeTaken.inSeconds;
    final timeBonus = _calculateTimeBonus(seconds);
    baseScore += timeBonus;

    return baseScore.clamp(0.0, 100.0);
  }

  double _calculateTimeBonus(int seconds) {
    // Bonus decreases linearly over time
    const maxBonusTime = 5; // 5 seconds for max bonus
    if (seconds <= maxBonusTime) return 50.0;

    const minBonusTime = 15; // 15 seconds for no bonus
    if (seconds >= minBonusTime) return 0.0;

    final ratio = 1 - ((seconds - maxBonusTime) / (minBonusTime - maxBonusTime));
    return 50.0 * ratio;
  }
}

/// Performance metrics for difficulty adaptation
class PerformanceMetrics {
  final int totalAttempts;
  final int correctAttempts;
  final Duration averageResponseTime;
  final int currentStreak;

  const PerformanceMetrics({
    required this.totalAttempts,
    required this.correctAttempts,
    required this.averageResponseTime,
    required this.currentStreak,
  });

  double get accuracy =>
      totalAttempts == 0 ? 0.0 : (correctAttempts / totalAttempts) * 100;

  /// Determines if difficulty should increase
  bool get shouldIncreaseDifficulty =>
      accuracy >= 80 && currentStreak >= 3 && averageResponseTime.inSeconds <= 8;

  /// Determines if difficulty should decrease
  bool get shouldDecreaseDifficulty =>
      accuracy <= 40 || currentStreak == 0 && averageResponseTime.inSeconds > 15;
}