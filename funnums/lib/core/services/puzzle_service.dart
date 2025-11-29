import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../data/models/puzzle.dart';

/// Puzzle service loading curated pools per difficulty from JSON assets.
class PuzzleService {
  Map<String, List<Puzzle>> _puzzlePools = {};
  final Map<String, int> _currentIndex = {};
  bool _loaded = false;

  Future<void> loadPools() async {
    if (_loaded) return;
    
    final jsonString = await rootBundle.loadString('assets/puzzles.json');
    final data = json.decode(jsonString) as Map<String, dynamic>;
    
    _puzzlePools = {};
    for (final entry in data.entries) {
      final difficulty = entry.key;
      final puzzleList = entry.value as List;
      
      final puzzles = puzzleList.map((p) => Puzzle(
        id: p['id'],
        difficulty: difficulty,
        sequence: List<int>.from(p['sequence']),
        missingIndex: p['missingIndex'],
        options: List<int>.from(p['options']),
        answer: p['answer'],
      )).toList();
      
      puzzles.shuffle(Random());
      _puzzlePools[difficulty] = puzzles;
      _currentIndex[difficulty] = 0;
    }
    _loaded = true;
  }

  Future<Puzzle> nextPuzzle(String difficulty) async {
    if (!_loaded) {
      await loadPools();
    }
    
    final pool = _puzzlePools[difficulty] ?? [];
    if (pool.isEmpty) {
      return Puzzle(
        id: 'fallback',
        difficulty: difficulty,
        sequence: const [1, 2, 4],
        missingIndex: 2,
        options: const [3, 5, 6],
        answer: 3,
      );
    }
    
    final index = _currentIndex[difficulty] ?? 0;
    final puzzle = pool[index];
    _currentIndex[difficulty] = (index + 1) % pool.length;
    
    return puzzle;
  }
}
