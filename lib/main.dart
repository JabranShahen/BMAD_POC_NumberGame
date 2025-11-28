import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared/models/puzzle.dart';
import 'shared/models/game_session.dart';

void main() {
  runApp(const PuzzleGameApp());
}

class PuzzleGameApp extends StatelessWidget {
  const PuzzleGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PuzzleGame',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late GameSession _session;
  late Puzzle _puzzle;
  String? _resultText;
  late Timer _timer;
  late AnimationController _animationController;
  int _remainingSeconds = 0;
  int _initialSeconds = 0;
  bool _timerExpired = false;
  DifficultyLevel _currentDifficulty = DifficultyLevel.medium;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs().then((_) {
      setState(() {
        _puzzle = _createSamplePuzzle();
        _initialSeconds = _puzzle.difficulty.timeSeconds;
        _remainingSeconds = _initialSeconds;
        _startTimer();
        _animationController = AnimationController(
          vsync: this,
          duration: Duration(seconds: _remainingSeconds),
        )..forward();
      });
    });
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _currentDifficulty = _loadDifficulty();
  }

  DifficultyLevel _loadDifficulty() {
    final levelStr = _prefs.getString('difficulty') ?? 'medium';
    return DifficultyLevel.values.firstWhere((e) => e.name == levelStr, orElse: () => DifficultyLevel.medium);
  }

  void _saveDifficulty(DifficultyLevel level) {
    _prefs.setString('difficulty', level.name);
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Puzzle _createSamplePuzzle() {
    // Simple arithmetic sequence: 2, 4, 6, 8 with 6 missing
    final sequence = [2, 4, 6, 8];
    const missingIndex = 2;
    const difficulty = DifficultyLevel.easy;
    final options = [4, 6, 10, 12];

    return Puzzle(
      id: 'demo-1',
      sequence: sequence,
      missingIndex: missingIndex,
      difficulty: difficulty,
      options: options,
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timerExpired = true;
          _resultText = "Time's up! ⏰";
          _timer.cancel();
          _animationController.stop();
        }
      });
    });
  }

  void _onAnswerSelected(int value) {
    _timer.cancel();
    _animationController.stop();
    final isCorrect = _puzzle.isCorrect(value);
    setState(() {
      _resultText = isCorrect ? 'Correct 🎉' : 'Try again ❌';
      if (!_timerExpired) {
        _resultText = '$_resultText (${_remainingSeconds}s remaining)';
      }
    });

    // Update difficulty after session analysis
    if (isCorrect) {
      final newDifficulty = DifficultyLevel.fromLevel(_currentDifficulty.level + 1);
      if (newDifficulty != _currentDifficulty) {
        _currentDifficulty = newDifficulty;
        _saveDifficulty(_currentDifficulty);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final displaySeq = _puzzle.displaySequence.join('  ');

    return Scaffold(
      appBar: AppBar(
        title: const Text('PuzzleGame'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_timerExpired)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$_remainingSeconds',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    CircularProgressIndicator(
                      value: _remainingSeconds / _initialSeconds.toDouble(),
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _remainingSeconds > _initialSeconds * 0.5 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32),
            Text(
              'Fill in the missing number:',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              displaySeq,
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(letterSpacing: 4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _puzzle.options.map((opt) {
                return ElevatedButton(
                  onPressed: () => _onAnswerSelected(opt),
                  child: Text(opt.toString()),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            if (_resultText != null)
              Text(
                _resultText!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
          ],
        ),
      ),
    );
  }
}
