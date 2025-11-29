import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/routing.dart';
import '../../core/services/puzzle_service.dart';
import '../../core/services/storage_service.dart';
import '../../data/models/puzzle.dart';
import '../../data/models/settings.dart';
import '../../data/sources/session_repository.dart';
import 'game_over_screen.dart';
import 'gameplay_controller.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late String _mode;
  late GameplayController _controller;
  late SettingsRepository _settingsRepo;
  Puzzle? _puzzle;
  int _remaining = 0;
  int _lives = 5;
  int _score = 0;
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;
  _FeedbackState _feedback = _FeedbackState.idle;
  Timer? _feedbackTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    _mode = (args['mode'] as String?) ?? 'fun';
    _settingsRepo = SettingsRepository(StorageService());
    _controller = GameplayController(
      mode: _mode,
      puzzleService: PuzzleService(),
      onPuzzle: (p) => setState(() => _puzzle = p),
      onTick: (remaining, lives) => setState(() {
        _remaining = remaining;
        _lives = lives;
        _score = _controller.score;
      }),
      onGameOver: _goToGameOver,
    );
    _loadSettings();
    _controller.start();
  }

  Future<void> _loadSettings() async {
    await _settingsRepo.initialize();
    final settings = await _settingsRepo.load();
    if (mounted) {
      setState(() {
        _soundEnabled = settings.soundEnabled;
        _hapticsEnabled = settings.hapticsEnabled;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _feedbackTimer?.cancel();
    super.dispose();
  }

  void _onAnswer(int value) {
    _controller.answer(value);
    _showFeedback(value == _controller.current?.answer);
  }

  void _goToGameOver(int finalScore) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.gameOver,
      arguments: GameOverArgs(mode: _mode, score: finalScore),
    );
  }

  void _showFeedback(bool correct) {
    _feedbackTimer?.cancel();
    setState(() {
      _feedback = correct ? _FeedbackState.correct : _FeedbackState.wrong;
    });
    if (_hapticsEnabled) {
      HapticFeedback.lightImpact();
    }
    _feedbackTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _feedback = _FeedbackState.idle;
        });
      }
    });
  }

  Future<void> _showSettingsSheet() async {
    bool sound = _soundEnabled;
    bool haptics = _hapticsEnabled;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, sheetSetState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Sound'),
                    value: sound,
                    onChanged: (val) => sheetSetState(() {
                      sound = val;
                    }),
                  ),
                  SwitchListTile(
                    title: const Text('Haptics'),
                    value: haptics,
                    onChanged: (val) => sheetSetState(() {
                      haptics = val;
                    }),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    setState(() {
      _soundEnabled = sound;
      _hapticsEnabled = haptics;
    });
    await _settingsRepo.save(AppSettings(soundEnabled: sound, hapticsEnabled: haptics, version: 1));
  }

  @override
  Widget build(BuildContext context) {
    final urgent = _remaining > 0 && _remaining <= 3;
    return Scaffold(
      appBar: AppBar(
        title: Text('$_mode mode'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsSheet,
            tooltip: 'Sound & haptics',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TimerChip(remaining: _remaining, urgent: urgent),
            _LivesRow(lives: _lives),
            _ScoreChip(score: _score),
          ],
        ),
            const SizedBox(height: 12),
            const Text('Find the missing number', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            if (_puzzle != null) _PuzzleCard(puzzle: _puzzle!, feedback: _feedback),
            const SizedBox(height: 16),
            if (_puzzle != null)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _puzzle!.options
                    .map((opt) => ElevatedButton(
                          onPressed: () => _onAnswer(opt),
                          style: opt == _puzzle!.answer ? ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ) : null,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Text(opt.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ))
                    .toList(),
              ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () => _goToGameOver(_controller.score),
                child: const Text('End run'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PuzzleCard extends StatelessWidget {
  final Puzzle puzzle;
  final _FeedbackState feedback;
  const _PuzzleCard({required this.puzzle, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final sequence = List<int>.from(puzzle.sequence);
    final display = <Widget>[];
    for (var i = 0; i < sequence.length; i++) {
      final isMissing = i == puzzle.missingIndex;
      display.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMissing ? Colors.amber.shade100 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          isMissing ? ' ? ' : sequence[i].toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ));
      if (i != sequence.length - 1) {
        display.add(const SizedBox(width: 8));
      }
    }

    final bgColor = feedback == _FeedbackState.correct
        ? Colors.green.shade50
        : feedback == _FeedbackState.wrong
            ? Colors.red.shade50
            : null;

    return Card(
      color: bgColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: display),
      ),
    );
  }
}

class _TimerChip extends StatelessWidget {
  final int remaining;
  final bool urgent;
  const _TimerChip({required this.remaining, required this.urgent});

  @override
  Widget build(BuildContext context) {
    final color = urgent ? Colors.red.shade600 : Theme.of(context).colorScheme.primary;
    final text = remaining > 0 ? '$remaining s' : 'Time';
    return Chip(
      backgroundColor: color.withAlpha(38),
      label: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _LivesRow extends StatelessWidget {
  final int lives;
  const _LivesRow({required this.lives});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        final active = index < lives;
        return Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Icon(
            active ? Icons.favorite : Icons.favorite_border,
            color: active ? Colors.pink : Colors.grey,
          ),
        );
      }),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final int score;
  const _ScoreChip({required this.score});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Colors.green.shade50,
      label: Text(
        'Score: $score',
        style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w700),
      ),
    );
  }
}

enum _FeedbackState { idle, correct, wrong }
