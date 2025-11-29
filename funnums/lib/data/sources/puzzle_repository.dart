import '../models/puzzle.dart';

/// Stub repository for puzzle pools.
/// TODO: Load from assets and ensure single-answer validation.
class PuzzleRepository {
  Future<void> load() async {
    // TODO: Load and validate puzzle pools.
  }

  Puzzle next(String difficulty) {
    // TODO: Pull next puzzle by difficulty with de-dup.
    return const Puzzle(
      id: 'placeholder',
      difficulty: 'fun',
      sequence: [1, 2, 4],
      missingIndex: 2,
      options: [3, 5, 6],
      answer: 3,
    );
  }
}
