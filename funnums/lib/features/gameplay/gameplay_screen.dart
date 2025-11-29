import 'package:flutter/material.dart';

import '../../core/routing.dart';
import '../../core/services/puzzle_service.dart';
import '../../data/models/puzzle.dart';
import 'gameplay_controller.dart';
import 'game_over_screen.dart';

class GameplayScreen extends StatefulWidget {
  const GameplayScreen({super.key});

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  late String _mode;
  late GameplayController _controller;
  Puzzle? _puzzle;
  int _remaining = 0;
  int _lives = 5;
  int _score = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    _mode = (args['mode'] as String?) ?? 'fun';
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
    _controller.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onAnswer(int value) {
    _controller.answer(value);
  }

  void _goToGameOver(int finalScore) {
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.gameOver,
      arguments: GameOverArgs(mode: _mode, score: finalScore),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urgent = _remaining > 0 && _remaining <= 3;
    return Scaffold(
      appBar: AppBar(
        title: Text('$_mode mode'),
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
            if (_puzzle != null) _PuzzleCard(puzzle: _puzzle!),
            const SizedBox(height: 16),
            if (_puzzle != null)
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _puzzle!.options
                    .map((opt) => ElevatedButton(
                          onPressed: () => _onAnswer(opt),
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
  const _PuzzleCard({required this.puzzle});

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

    return Card(
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
      backgroundColor: color.withOpacity(0.15),
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
