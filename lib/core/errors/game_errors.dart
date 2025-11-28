/// Custom exceptions for game-specific errors
class GameError implements Exception {
  final String message;
  final String? code;

  const GameError(this.message, {this.code});

  @override
  String toString() => 'GameError${code != null ? '[$code]' : ''}: $message';
}

class PuzzleGenerationError extends GameError {
  const PuzzleGenerationError(String message) : super(message, code: 'PUZZLE_GEN');
}

class ValidationError extends GameError {
  const ValidationError(String message) : super(message, code: 'VALIDATION');
}

class DifficultyAdjustmentError extends GameError {
  const DifficultyAdjustmentError(String message) : super(message, code: 'DIFFICULTY');
}

class StorageError extends GameError {
  const StorageError(String message) : super(message, code: 'STORAGE');
}