import 'dart:async';

import '../../core/services/puzzle_service.dart';
import '../../data/models/puzzle.dart';

typedef PuzzleCallback = void Function(Puzzle puzzle);
typedef TickCallback = void Function(int remainingSeconds, int lives);
typedef GameOverCallback = void Function(int finalScore);

class GameplayController {
  GameplayController({
    required this.mode,
    required this.onPuzzle,
    required this.onTick,
    required this.onGameOver,
    PuzzleService? puzzleService,
  }) : _puzzleService = puzzleService ?? PuzzleService();

  final String mode;
  final PuzzleCallback onPuzzle;
  final TickCallback onTick;
  final GameOverCallback onGameOver;
  final PuzzleService _puzzleService;

  static const Map<String, int> _modeSeconds = {
    'fun': 8,
    'medium': 6,
    'hard': 4,
  };

  int lives = 5;
  int score = 0;
  int _remaining = 0;
  Puzzle? current;
  Timer? _timer;

  void start() {
    lives = 5;
    score = 0;
    _loadNextPuzzle();
  }

  void _startTimer() {
    _timer?.cancel();
    _remaining = _modeSeconds[mode] ?? 8;
    onTick(_remaining, lives);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _remaining -= 1;
      if (_remaining <= 0) {
        _timer?.cancel();
        _handleTimeout();
      } else {
        onTick(_remaining, lives);
      }
    });
  }

  void _handleTimeout() {
    _loseLife();
  }

  void _loadNextPuzzle() {
    current = _puzzleService.nextPuzzle(mode);
    onPuzzle(current!);
    _startTimer();
  }

  void answer(int value) {
    _timer?.cancel();
    final correct = value == current?.answer;
    if (correct) {
      score += 1;
      _loadNextPuzzle();
    } else {
      _loseLife();
    }
  }

  void _loseLife() {
    lives -= 1;
    if (lives <= 0) {
      onTick(0, lives);
      onGameOver(score);
    } else {
      onTick(_modeSeconds[mode] ?? 8, lives);
      _loadNextPuzzle();
    }
  }

  void dispose() {
    _timer?.cancel();
  }
}
