// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import '../../core/di.dart';
import '../../core/routing.dart';
import '../../data/sources/session_repository.dart';
import 'widgets/emoji_avatar.dart';

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
  SessionRepository? _repo;
  bool _saved = false;
  String? _mode;
  int? _score;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_mode != null) return; // Already initialized
    final args = ModalRoute.of(context)?.settings.arguments as GameOverArgs?;
    _mode = args?.mode ?? 'fun';
    _score = args?.score ?? 0;
    _repo = SessionRepository(Services.storage);
    _persistOnce();
  }

  Future<void> _persistOnce() async {
    if (_saved || _repo == null) return;
    _saved = true;
    await _repo!.initialize();
    await _repo!.saveBestScore(_mode!, _score!);
    await _repo!.saveLastScore(_mode!, _score!);
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
                const EmojiAvatarWidget(
                  lives: 0,
                  remainingSeconds: 0,
                  gameOver: true,
                  isDifficultyScreen: false,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tough break this run', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('Your score is saved. Ready for another try?', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Mode: ${_mode ?? 'fun'}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text((_score ?? 0).toString(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.gameplay, arguments: {'mode': _mode ?? 'fun'}),
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
