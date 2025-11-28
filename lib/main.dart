import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

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

class SimplePuzzle {
  final List<int> sequence;
  final int missingIndex;
  final List<int> options;

  SimplePuzzle({required this.sequence, required this.missingIndex, required this.options});

  List<String> get displaySequence {
    final display = List<String>.from(sequence.map((e) => e.toString()));
    display[missingIndex] = '?';
    return display;
  }

  bool isCorrect(int answer) => sequence[missingIndex] == answer;
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  SimplePuzzle? _puzzle;
  String? _resultText;
  Timer? _timer;
  AnimationController? _animationController;
  int _remainingSeconds = 0;
  int _initialSeconds = 0;
  bool _timerExpired = false;
  int _currentDifficulty = 2;
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _startNewPuzzle();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _currentDifficulty = _prefs?.getInt('difficulty') ?? 2;
  }

  void _saveDifficulty(int level) {
    _prefs?.setInt('difficulty', level);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _animationController?.dispose();
    super.dispose();
  }

  void _startNewPuzzle() {
    setState(() {
      _puzzle = _createSamplePuzzle();
      _initialSeconds = 30;
      _remainingSeconds = _initialSeconds;
      _resultText = null;
      _timerExpired = false;
      _startTimer();
      _animationController?.dispose();
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: _remainingSeconds),
      )..forward();
    });
  }

  SimplePuzzle _createSamplePuzzle() {
    final random = Random();
    final start = random.nextInt(10) + 1;
    final step = random.nextInt(5) + 1;
    final sequence = List.generate(4, (i) => start + (i * step));
    final missingIndex = random.nextInt(4);
    final correctAnswer = sequence[missingIndex];
    
    final options = <int>[correctAnswer];
    while (options.length < 4) {
      final wrong = correctAnswer + random.nextInt(20) - 10;
      if (wrong > 0 && !options.contains(wrong)) options.add(wrong);
    }
    options.shuffle();

    return SimplePuzzle(
      sequence: sequence,
      missingIndex: missingIndex,
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
          _timer?.cancel();
          _animationController?.stop();
          // Trigger new puzzle after feedback delay
          Future.delayed(const Duration(milliseconds: 800), _startNewPuzzle);
        }
      });
    });
  }

  void _onAnswerSelected(int value) {
    _timer?.cancel();
    _animationController?.stop();
    final isCorrect = _puzzle!.isCorrect(value);
    setState(() {
      _resultText = isCorrect ? 'Correct 🎉' : 'Try again ❌';
      if (!_timerExpired) {
        _resultText = '$_resultText (${_remainingSeconds}s remaining)';
      }
    });

    if (isCorrect && _currentDifficulty < 5) {
      _currentDifficulty++;
      _saveDifficulty(_currentDifficulty);
    }

    // Trigger new puzzle after feedback delay
    Future.delayed(const Duration(milliseconds: 800), _startNewPuzzle);
  }

  @override
  Widget build(BuildContext context) {
    if (_puzzle == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('PuzzleGame')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    
    final displaySeq = _puzzle!.displaySequence.join('  ');

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
              children: _puzzle!.options.map((opt) {
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
