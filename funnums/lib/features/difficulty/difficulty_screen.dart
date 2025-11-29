import 'package:flutter/material.dart';

import '../../core/routing.dart';
import '../../core/services/storage_service.dart';
import '../../data/sources/session_repository.dart';

class DifficultyScreen extends StatefulWidget {
  const DifficultyScreen({super.key});

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  late final SessionRepository _sessionRepo;
  Map<String, int> _bests = const {'fun': 0, 'medium': 0, 'hard': 0};
  Map<String, int> _last = const {'fun': 0, 'medium': 0, 'hard': 0};

  @override
  void initState() {
    super.initState();
    _sessionRepo = SessionRepository(StorageService());
    _loadBests();
  }

  Future<void> _loadBests() async {
    await _sessionRepo.initialize(); // ensure storage ready
    final bests = await _sessionRepo.loadBestScores();
    final last = await _sessionRepo.loadLastScores();
    if (mounted) {
      setState(() {
        _bests = bests;
        _last = last;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = [
      _DifficultyOption('Fun', '8s timer', _bests['fun'] ?? 0, _last['fun'] ?? 0, 'fun'),
      _DifficultyOption('Medium', '6s timer', _bests['medium'] ?? 0, _last['medium'] ?? 0, 'medium'),
      _DifficultyOption('Hard', '4s timer', _bests['hard'] ?? 0, _last['hard'] ?? 0, 'hard'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose your challenge'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pick a mode to start',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final opt = options[index];
                  return _DifficultyCard(
                    title: opt.title,
                    subtitle: opt.subtitle,
                    badge: 'Best: ${opt.best}',
                    last: 'Last: ${opt.last}',
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.gameplay,
                      arguments: {'mode': opt.key},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyOption {
  final String title;
  final String subtitle;
  final int best;
  final int last;
  final String key;
  _DifficultyOption(this.title, this.subtitle, this.best, this.last, this.key);
}

class _DifficultyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final String last;
  final VoidCallback onTap;
  const _DifficultyCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.last,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Chip(label: Text(badge)),
                  const SizedBox(height: 4),
                  Text(last, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
