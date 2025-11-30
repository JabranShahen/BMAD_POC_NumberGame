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
import 'widgets/answer_button.dart';
import 'widgets/emoji_avatar.dart';

// Palette for upgraded layout
const _lynxWhite = Color(0xFFF5F6F8);
const _vanadylBlue = Color(0xFF6A8FD8);
const _periwinkle = Color(0xFFDDE6FF);
const _blueberrySoda = Color(0xFFA5B4FF);
const _skirretGreen = Color(0xFF38B48C);
const _nasturcianFlower = Color(0xFFE86A33);
const _mazarineBlue = Color(0xFF273469);

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
  int? _selectedAnswer;
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
      onPuzzle: (p) => setState(() {
        _puzzle = p;
        _selectedAnswer = null;
      }),
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
    setState(() {
      _selectedAnswer = value;
    });
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_periwinkle, _lynxWhite],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_puzzle != null)
                      _PuzzleCard(
                        puzzle: _puzzle!,
                        feedback: _feedback,
                      ),
                    const SizedBox(height: 24),
                    EmojiAvatarWidget(
                      lives: _lives,
                      remainingSeconds: _remaining,
                      gameOver: false,
                      isDifficultyScreen: false,
                      useHeroSize: true,
                      loop: false,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TimerChip(remaining: _remaining, urgent: urgent),
                        const SizedBox(width: 14),
                        _LivesRow(lives: _lives, iconSize: 28),
                        const SizedBox(width: 14),
                        _ScoreChip(score: _score),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Find the missing number',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: _mazarineBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    if (_puzzle != null)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _puzzle!.options.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.6,
                        ),
                        itemBuilder: (context, index) {
                          final opt = _puzzle!.options[index];
                          final isCorrect = _puzzle!.answer == opt;
                          final isSelected = _selectedAnswer == opt;
                          return AnswerButton(
                            label: opt.toString(),
                            onTap: () => _onAnswer(opt),
                            isCorrect: isCorrect,
                            isSelected: isSelected,
                            showResult: _selectedAnswer != null,
                            palette: const AnswerPalette(
                              base: _vanadylBlue,
                              correct: _skirretGreen,
                              incorrect: _nasturcianFlower,
                              text: Colors.white,
                            ),
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _goToGameOver(_controller.score),
                        style: TextButton.styleFrom(
                          foregroundColor: _vanadylBlue,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                        child: const Text(
                          'End run',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
    final colors = Theme.of(context).colorScheme;
    final sequence = List<int>.from(puzzle.sequence);
    final display = <Widget>[];
    for (var i = 0; i < sequence.length; i++) {
      final isMissing = i == puzzle.missingIndex;
      display.add(Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isMissing ? _blueberrySoda.withAlpha(40) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          isMissing ? ' ? ' : sequence[i].toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isMissing ? _vanadylBlue : colors.onSurface,
          ),
        ),
      ));
      if (i != sequence.length - 1) {
        display.add(const SizedBox(width: 8));
      }
    }

    final bgColor = feedback == _FeedbackState.correct
        ? colors.primary.withAlpha(20)
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
    const base = _vanadylBlue;
    final bg = urgent ? _nasturcianFlower.withAlpha(28) : base.withAlpha(24);
    final textColor = urgent ? _nasturcianFlower : base;
    final text = remaining > 0 ? '$remaining s' : 'Time';
    return Chip(
      backgroundColor: bg,
      label: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _LivesRow extends StatelessWidget {
  final int lives;
  final double iconSize;
  const _LivesRow({required this.lives, this.iconSize = 22});

  @override
  Widget build(BuildContext context) {
    const primary = _vanadylBlue;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: List.generate(5, (index) {
          final active = index < lives;
          return Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Icon(
              active ? Icons.favorite : Icons.favorite_border,
              color: active ? primary : Colors.grey,
              size: iconSize,
            ),
          );
        }),
      ),
    );
  }
}

class _ScoreChip extends StatelessWidget {
  final int score;
  const _ScoreChip({required this.score});

  @override
  Widget build(BuildContext context) {
    const secondary = _vanadylBlue;
    return Chip(
      backgroundColor: secondary.withAlpha(22),
      label: Text(
        'Score: $score',
        style: const TextStyle(color: _vanadylBlue, fontWeight: FontWeight.w700),
      ),
    );
  }
}

enum _FeedbackState { idle, correct, wrong }
