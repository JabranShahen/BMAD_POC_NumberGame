// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AnswerPalette {
  final Color base;
  final Color correct;
  final Color incorrect;
  final Color text;
  const AnswerPalette({
    required this.base,
    required this.correct,
    required this.incorrect,
    required this.text,
  });
}

class AnswerButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isCorrect;
  final bool isSelected;
  final bool showResult;
  final AnswerPalette palette;
  const AnswerButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.isCorrect,
    required this.isSelected,
    required this.showResult,
    required this.palette,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton> {
  bool _pressed = false;

  void _handleTapDown(_) {
    setState(() => _pressed = true);
  }

  void _handleTapEnd(_) {
    setState(() => _pressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final base = widget.palette.base;
    Color overlay;
    if (widget.showResult && widget.isSelected) {
      overlay = widget.isCorrect ? widget.palette.correct : widget.palette.incorrect;
    } else {
      overlay = base;
    }
    return AnimatedScale(
      scale: _pressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: base,
          foregroundColor: widget.palette.text,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0.5,
          shadowColor: base.withAlpha(60),
        ).copyWith(
          overlayColor: MaterialStateProperty.all(overlay.withAlpha(70)),
        ),
        onFocusChange: (_) {},
        onHover: (_) {},
        child: Listener(
          onPointerDown: _handleTapDown,
          onPointerUp: _handleTapEnd,
          onPointerCancel: _handleTapEnd,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              widget.label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
