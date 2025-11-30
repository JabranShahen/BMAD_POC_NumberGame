import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// Emoji avatar that mirrors player state with optional animated assets and
/// graceful fallbacks (static emoji if assets or animations are unavailable).
class EmojiAvatarWidget extends StatefulWidget {
  const EmojiAvatarWidget({
    super.key,
    required this.lives,
    required this.remainingSeconds,
    required this.gameOver,
    required this.isDifficultyScreen,
    this.reduceMotion,
    this.useHeroSize = false,
    this.loop = true,
  });

  final int lives;
  final int remainingSeconds;
  final bool gameOver;
  final bool isDifficultyScreen;
  final bool? reduceMotion;
  final bool useHeroSize;
  final bool loop;

  @override
  State<EmojiAvatarWidget> createState() => _EmojiAvatarWidgetState();
}

class _EmojiAvatarWidgetState extends State<EmojiAvatarWidget> {
  static const _assetMap = {
    'difficulty': 'assets/animated_emoji/-grinning-.json',
    'welcome': 'assets/animated_emoji/-hug-face-.json',
    'lives5': 'assets/animated_emoji/-smile-.json',
    'lives4': 'assets/animated_emoji/-smile-.json',
    'lives3': 'assets/animated_emoji/-grimacing-.json',
    'lives2': 'assets/animated_emoji/-flushed-.json',
    'lives1': 'assets/animated_emoji/-scared-.json',
    'gameover': 'assets/animated_emoji/-dizzy-face-.json',
  };

  static const _emojiMap = {
    'difficulty': '😊',
    'welcome': '😊',
    'lives5': '🙂', // calm, confident
    'lives4': '😊', // soft smile, doing fine
    'lives3': '😕', // concerned / unsure
    'lives2': '😰', // worried / stressed
    'lives1': '😱', // fear / panic
    'gameover': '😵', // dizzy / game-over
  };

  String _stateKey() {
    if (widget.gameOver || widget.lives <= 0) return 'gameover';
    if (widget.isDifficultyScreen) return 'welcome';
    switch (widget.lives) {
      case 5:
        return 'lives5';
      case 4:
        return 'lives4';
      case 3:
        return 'lives3';
      case 2:
        return 'lives2';
      case 1:
        return 'lives1';
      default:
        return 'lives5';
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = _stateKey();
    final asset = _assetMap[key];
    final emoji = _emojiMap[key] ?? '🙂';
    final reduceMotion = widget.reduceMotion ?? MediaQuery.of(context).disableAnimations;
    final hero = widget.isDifficultyScreen || widget.gameOver || widget.useHeroSize;
    final size = hero ? 96.0 : 56.0;
    final bgColor = Theme.of(context).colorScheme.secondary.withAlpha(31); // ~12%

    final semantic = _semanticLabel(emoji);

    return Semantics(
      label: semantic,
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: reduceMotion || asset == null
              ? Text(
                  emoji,
                  style: TextStyle(fontSize: hero ? 208 : 112),
                )
              : Lottie.asset(
                  asset,
                  width: size * 0.8,
                  height: size * 0.8,
                  repeat: widget.loop,
                  key: ValueKey('state-$key-${widget.lives}-${widget.gameOver}'),
                  frameRate: FrameRate.max,
                  errorBuilder: (_, __, ___) => Text(
                    emoji,
                    style: TextStyle(fontSize: hero ? 208 : 112),
                  ),
                ),
        ),
      ),
    );
  }

  String _semanticLabel(String emoji) {
    if (widget.gameOver || widget.lives <= 0) return '$emoji avatar, game over';
    return '$emoji avatar, ${widget.lives} lives left';
  }
}
