import 'package:flutter/material.dart';

import '../../core/routing.dart';
import '../../core/services/storage_service.dart';
import '../../data/sources/session_repository.dart';

class GameOverArgs {
  final String mode;
  final int score;
  const GameOverArgs({required this.mode, required this.score});
}

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as GameOverArgs?;
    final mode = args?.mode ?? 'fun';
    final score = args?.score ?? 0;
    final repo = SessionRepository(StorageService());
    // Persist last/best scores (ignore async result here for simplicity).
    repo.saveBestScore(mode, score);
    repo.saveLastScore(mode, score);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Over'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mode: $mode', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Text(score.toString(), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.gameplay, arguments: {'mode': mode}),
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
