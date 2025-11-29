import 'package:flutter/material.dart';

import '../../core/di.dart';
import '../../core/routing.dart';
import '../../data/sources/session_repository.dart';

class GameOverArgs {
  final String mode;
  final int score;
  const GameOverArgs({required this.mode, required this.score});
}

class GameOverScreen extends StatefulWidget {
  const GameOverScreen({super.key});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  late final SessionRepository _repo;
  bool _saved = false;
  late final String _mode;
  late final int _score;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as GameOverArgs?;
    _mode = args?.mode ?? 'fun';
    _score = args?.score ?? 0;
    _repo = SessionRepository(Services.storage);
    _persistOnce();
  }

  Future<void> _persistOnce() async {
    if (_saved) return;
    _saved = true;
    await _repo.initialize();
    await _repo.saveBestScore(_mode, _score);
    await _repo.saveLastScore(_mode, _score);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _GameOverEmoji(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Tough break this run', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('Your score is saved. Ready for another try?', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Mode: $_mode', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(_score.toString(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.gameplay, arguments: {'mode': _mode}),
                    child: const Text('Play again'),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.difficulty),
                  child: const Text('Change difficulty'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _GameOverEmoji extends StatelessWidget {
  const _GameOverEmoji();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.red.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Text(
        '😵',
        style: TextStyle(fontSize: 32),
      ),
    );
  }
}
