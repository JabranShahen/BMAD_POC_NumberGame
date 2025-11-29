import 'package:flutter/material.dart';

import '../../core/di.dart';
import '../../core/routing.dart';
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
    _sessionRepo = SessionRepository(Services.storage);
    _loadScores();
  }

  Future<void> _loadScores() async {
    await _sessionRepo.initialize();
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
      _DifficultyOption(
        'Fun',
        'Fun - 8s per puzzle',
        _bests['fun'] ?? 0,
        _last['fun'] ?? 0,
        'fun',
        Icons.sentiment_satisfied_rounded,
        const Color(0xFF3F7BB9), // Seabrook
      ),
      _DifficultyOption(
        'Medium',
        'Medium - 6s per puzzle',
        _bests['medium'] ?? 0,
        _last['medium'] ?? 0,
        'medium',
        Icons.adjust_rounded,
        const Color(0xFFD14A28), // Harley Orange
      ),
      _DifficultyOption(
        'Hard',
        'Hard - 4s per puzzle',
        _bests['hard'] ?? 0,
        _last['hard'] ?? 0,
        'hard',
        Icons.whatshot_rounded,
        const Color(0xFF1F2F55), // Deep Navy
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final opt = options[index];
                  return _DifficultyCard(
                    title: opt.title,
                    subtitle: opt.subtitle,
                    badge: 'Best: ${opt.best}',
                    last: 'Last: ${opt.last}',
                    icon: opt.icon,
                    onTap: () async {
                      await Navigator.pushNamed(
                        context,
                        AppRoutes.gameplay,
                        arguments: {'mode': opt.key},
                      );
                      if (mounted) {
                        _loadScores();
                      }
                    },
                    fillColor: opt.fillColor,
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
  final IconData icon;
  final Color fillColor;
  _DifficultyOption(this.title, this.subtitle, this.best, this.last, this.key, this.icon, this.fillColor);
}

class _DifficultyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String badge;
  final String last;
  final IconData icon;
  final VoidCallback onTap;
  final Color fillColor;
  const _DifficultyCard({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.last,
    required this.icon,
    required this.onTap,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD6A21F);
    const neutral = Color(0xFFF0F2F5);
    final pressedColor = Color.lerp(fillColor, Colors.black, 0.10)!;
    final focusColor = gold.withOpacity(0.35);
    return Card(
      margin: EdgeInsets.zero,
      color: fillColor,
      surfaceTintColor: fillColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        splashColor: pressedColor.withOpacity(0.12),
        focusColor: focusColor,
        hoverColor: pressedColor.withOpacity(0.08),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _Tag(badge, bg: gold, fg: Colors.white),
                        const SizedBox(width: 8),
                        _Tag(last, bg: neutral, fg: Colors.grey.shade800),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  final Color bg;
  final Color? fg;
  const _Tag(this.text, {this.bg = const Color(0xFFE5E7EB), this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg ?? Colors.black87),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    const deep = Color(0xFF1F2F55);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [secondary, deep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Choose your challenge',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                SizedBox(height: 6),
                Text(
                  'Pick a pace that fits you. Best score and last run shown for each mode.',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const _EmojiBadge(emoji: '😄'),
        ],
      ),
    );
  }
}

class _EmojiBadge extends StatelessWidget {
  final String emoji;
  const _EmojiBadge({required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.16),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 26),
      ),
    );
  }
}
