/// Core puzzle entities and types

/// Difficulty levels for puzzles
enum DifficultyLevel {
  easy(1, 'Easy', 3, 8, 15),
  medium(2, 'Medium', 4, 10, 10),
  hard(3, 'Hard', 5, 12, 8);

  const DifficultyLevel(
    this.level,
    this.displayName,
    this.sequenceLength,
    this.maxNumber,
    this.timeSeconds,
  );

  final int level;
  final String displayName;
  final int sequenceLength;
  final int maxNumber;
  final int timeSeconds;

  static DifficultyLevel fromLevel(int level) {
    return DifficultyLevel.values.firstWhere(
      (d) => d.level == level,
      orElse: () => DifficultyLevel.medium,
    );
  }
}

/// Represents a puzzle to be solved
class Puzzle {
  final String id;
  final List<int> sequence;
  final int missingIndex;
  final DifficultyLevel difficulty;
  final DateTime generatedAt;
  final List<int> options;

  Puzzle({
    required this.id,
    required this.sequence,
    required this.missingIndex,
    required this.difficulty,
    required this.options,
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();

  /// The correct answer
  int get correctAnswer => sequence[missingIndex];

  /// Creates a display sequence with blank at missing index
  List<String> get displaySequence {
    return sequence.asMap().entries.map((entry) {
      return entry.key == missingIndex ? '_' : entry.value.toString();
    }).toList();
  }

  /// Checks if an answer is correct
  bool isCorrect(int answer) => answer == correctAnswer;

  /// Validates if options contain the correct answer
  bool get isValid => options.contains(correctAnswer);
}

/// Represents an attempt to solve a puzzle
class PuzzleAttempt {
  final String puzzleId;
  final int selectedAnswer;
  final Duration timeTaken;
  final DateTime attemptedAt;

  PuzzleAttempt({
    required this.puzzleId,
    required this.selectedAnswer,
    required this.timeTaken,
    DateTime? attemptedAt,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  /// Score based on correctness and speed (0-100)
  double get score {
    if (!isCorrect) return 0.0;

    // Base score for correctness
    double baseScore = 50.0;

    // Time bonus (faster = higher score)
    final timeBonus = _calculateTimeBonus();
    baseScore += timeBonus;

    // Streak bonus would be calculated at session level
    return baseScore.clamp(0.0, 100.0);
  }

  /// Whether the attempt was correct
  bool get isCorrect => selectedAnswer == correctAnswer;

  int get correctAnswer => 0; // Would be looked up from puzzle

  double _calculateTimeBonus() {
    // Max bonus for very fast answers, decreasing over time
    const maxTimeMs = 10000; // 10 seconds max for bonus
    final timeMs = timeTaken.inMilliseconds;

    if (timeMs >= maxTimeMs) return 0.0;

    // Exponential decay bonus
    return 50.0 * (1 - (timeMs / maxTimeMs));
  }
}

/// Performance data for difficulty adaptation
class PerformanceData {
  final int totalAttempts;
  final int correctAttempts;
  final Duration averageTime;
  final int currentStreak;
  final DifficultyLevel currentLevel;

  PerformanceData({
    required this.totalAttempts,
    required this.correctAttempts,
    required this.averageTime,
    required this.currentStreak,
    required this.currentLevel,
  });

  double get accuracy =>
      totalAttempts == 0 ? 0.0 : (correctAttempts / totalAttempts) * 100;

  /// Determines recommended difficulty level
  DifficultyLevel get recommendedLevel {
    if (accuracy >= 85 && currentStreak >= 5) {
      // Doing very well, increase difficulty
      return DifficultyLevel.fromLevel(currentLevel.level + 1);
    }
    // Keep current level (never regress without player choice)
    return currentLevel;
  }
}