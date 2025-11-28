import '../../domain/entities/puzzle_entity.dart';

/// Data model for puzzle persistence and API
class PuzzleModel {
  final String id;
  final List<int> sequence;
  final int missingIndex;
  final String difficulty;
  final DateTime generatedAt;
  final List<int> options;

  PuzzleModel({
    required this.id,
    required this.sequence,
    required this.missingIndex,
    required this.difficulty,
    required this.options,
    DateTime? generatedAt,
  }) : generatedAt = generatedAt ?? DateTime.now();

  /// Converts to domain entity
  PuzzleEntity toEntity() {
    return PuzzleEntity(
      sequence: sequence,
      missingIndex: missingIndex,
      difficulty: _difficultyFromString(difficulty),
      options: options,
    );
  }

  /// Creates from domain entity
  factory PuzzleModel.fromEntity(PuzzleEntity entity, String id) {
    return PuzzleModel(
      id: id,
      sequence: entity.sequence,
      missingIndex: entity.missingIndex,
      difficulty: entity.difficulty.name,
      options: entity.options,
      generatedAt: DateTime.now(),
    );
  }

  /// Creates from JSON
  factory PuzzleModel.fromJson(Map<String, dynamic> json) {
    return PuzzleModel(
      id: json['id'] as String,
      sequence: List<int>.from(json['sequence'] as List),
      missingIndex: json['missingIndex'] as int,
      difficulty: json['difficulty'] as String,
      options: List<int>.from(json['options'] as List),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sequence': sequence,
      'missingIndex': missingIndex,
      'difficulty': difficulty,
      'options': options,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  Difficulty _difficultyFromString(String difficultyStr) {
    return Difficulty.values.firstWhere(
      (d) => d.name == difficultyStr,
      orElse: () => Difficulty.medium,
    );
  }
}

/// Model for storing puzzle attempts
class PuzzleAttemptModel {
  final String puzzleId;
  final int selectedAnswer;
  final int timeTakenMs;
  final DateTime attemptedAt;

  PuzzleAttemptModel({
    required this.puzzleId,
    required this.selectedAnswer,
    required this.timeTakenMs,
    DateTime? attemptedAt,
  }) : attemptedAt = attemptedAt ?? DateTime.now();

  /// Creates from JSON
  factory PuzzleAttemptModel.fromJson(Map<String, dynamic> json) {
    return PuzzleAttemptModel(
      puzzleId: json['puzzleId'] as String,
      selectedAnswer: json['selectedAnswer'] as int,
      timeTakenMs: json['timeTakenMs'] as int,
      attemptedAt: DateTime.parse(json['attemptedAt'] as String),
    );
  }

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'puzzleId': puzzleId,
      'selectedAnswer': selectedAnswer,
      'timeTakenMs': timeTakenMs,
      'attemptedAt': attemptedAt.toIso8601String(),
    };
  }
}