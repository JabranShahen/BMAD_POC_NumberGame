import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../../../shared/models/puzzle.dart';

/// JSON-compatible puzzle model
class PuzzleModel {
  final String id;
  final List<int> sequence;
  final int missingIndex;
  final String difficulty;
  final List<int> options;

  PuzzleModel({
    required this.id,
    required this.sequence,
    required this.missingIndex,
    required this.difficulty,
    required this.options,
  });

  factory PuzzleModel.fromJson(Map<String, dynamic> json) {
    return PuzzleModel(
      id: json['id'],
      sequence: List<int>.from(json['sequence']),
      missingIndex: json['missingIndex'],
      difficulty: json['difficulty'],
      options: List<int>.from(json['options']),
    );
  }

  /// Convert to domain Puzzle entity
  Puzzle toPuzzle() {
    return Puzzle(
      id: id,
      sequence: sequence,
      missingIndex: missingIndex,
      difficulty: _parseDifficulty(difficulty),
      options: options,
    );
  }

  DifficultyLevel _parseDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return DifficultyLevel.easy;
      case 'medium':
        return DifficultyLevel.medium;
      case 'hard':
        return DifficultyLevel.hard;
      default:
        return DifficultyLevel.medium;
    }
  }
}

/// Repository for loading puzzles from JSON
class PuzzleRepository {
  static const String _puzzlesAssetPath = 'assets/puzzles.json';
  List<PuzzleModel>? _cachedPuzzles;

  /// Load all puzzles from JSON asset
  Future<List<PuzzleModel>> _loadPuzzles() async {
    if (_cachedPuzzles != null) return _cachedPuzzles!;

    final jsonString = await rootBundle.loadString(_puzzlesAssetPath);
    final jsonData = json.decode(jsonString) as List<dynamic>;

    _cachedPuzzles = jsonData.map((json) => PuzzleModel.fromJson(json)).toList();
    return _cachedPuzzles!;
  }

  /// Get a random puzzle of matching difficulty
  Future<Puzzle> getRandomPuzzle(DifficultyLevel difficulty) async {
    final allPuzzles = await _loadPuzzles();
    final matchingPuzzles = allPuzzles.where((p) => p.difficulty == difficulty.name).toList();

    if (matchingPuzzles.isEmpty) {
      throw Exception('No puzzles found for difficulty: ${difficulty.name}');
    }

    matchingPuzzles.shuffle(); // Randomize order
    return matchingPuzzles.first.toPuzzle();
  }

  /// Get all puzzles (for debugging/testing)
  Future<List<Puzzle>> getAllPuzzles() async {
    final models = await _loadPuzzles();
    return models.map((m) => m.toPuzzle()).toList();
  }
}