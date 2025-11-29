import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  });

  final int lives;
  final int remainingSeconds;
  final bool gameOver;
  final bool isDifficultyScreen;
  final bool? reduceMotion;

  @override
  State<EmojiAvatarWidget> createState() => _EmojiAvatarWidgetState();
}

class _EmojiAvatarWidgetState extends State<EmojiAvatarWidget> {
  static const _assetMap = {
    'difficulty': 'assets/animated_emoji/face-grinning.json',
    'lives5': 'assets/animated_emoji/face-laughing.json',
    'lives4': 'assets/animated_emoji/face-smiling.json',
    'lives3': 'assets/animated_emoji/face-grimacing.json',
    'lives2': 'assets/animated_emoji/face-flushed.json',
    'lives1': 'assets/animated_emoji/face-fearful.json',
    'panic': 'assets/animated_emoji/face-cold-sweat.json',
    'gameover': 'assets/animated_emoji/face-dizzy.json',
  };

  static const _emojiMap = {
    'difficulty': '😀',
    'lives5': '😁',
    'lives4': '😊',
    'lives3': '😬',
    'lives2': '😳',
    'lives1': '😨',
    'panic': '😰',
    'gameover': '😵',
  };

  final Map<String, Future<bool>> _assetExistsCache = {};

  String _stateKey() {
    if (widget.gameOver || widget.lives <= 0) return 'gameover';
    if (!widget.isDifficultyScreen && widget.remainingSeconds > 0 && widget.remainingSeconds <= 3) {
      return 'panic';
    }
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
        return widget.isDifficultyScreen ? 'difficulty' : 'lives5';
    }
  }

  Future<bool> _assetExists(String asset) {
    return _assetExistsCache.putIfAbsent(asset, () async {
      try {
        await rootBundle.load(asset);
        return true;
      } catch (_) {
        return false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = _stateKey();
    final asset = _assetMap[key];
    final emoji = _emojiMap[key] ?? '😀';
    final reduceMotion = widget.reduceMotion ?? MediaQuery.of(context).disableAnimations;
    final hero = widget.isDifficultyScreen || widget.gameOver;
    final size = hero ? 96.0 : 56.0;
    final bgColor = Theme.of(context).colorScheme.secondary.withOpacity(0.12);
    final borderColor = Theme.of(context).colorScheme.secondary.withOpacity(0.35);
    final semantic = _semanticLabel(emoji);

    return Semantics(
      label: semantic,
      child: Container(
        padding: EdgeInsets.all(hero ? 14 : 10),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: reduceMotion || asset == null
            ? Text(
                emoji,
                style: TextStyle(fontSize: hero ? 52 : 28),
              )
            : FutureBuilder<bool>(
                future: _assetExists(asset),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done || snapshot.data != true) {
                    return Text(
                      emoji,
                      style: TextStyle(fontSize: hero ? 52 : 28),
                    );
                  }
                  return SizedBox(
                    width: size,
                    height: size,
                    child: Lottie.asset(
                      asset,
                      repeat: true,
                      frameRate: FrameRate.max,
                      errorBuilder: (_, __, ___) => Text(
                        emoji,
                        style: TextStyle(fontSize: hero ? 52 : 28),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  String _semanticLabel(String emoji) {
    if (widget.gameOver || widget.lives <= 0) return '$emoji avatar, game over';
    if (widget.remainingSeconds > 0 && widget.remainingSeconds <= 3) {
      return '$emoji avatar, timer critical, ${widget.lives} lives left';
    }
    return '$emoji avatar, ${widget.lives} lives left';
  }
}
