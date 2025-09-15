import 'package:flutter/material.dart';

class ZoomText extends StatefulWidget {
  final Text text;
  final Duration duration;
  final Curve curve;

  const ZoomText({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 700),
    this.curve = Curves.easeInOut,
  });

  @override
  State<ZoomText> createState() => _ZoomTextState();
}

class _ZoomTextState extends State<ZoomText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: widget.duration)..forward();

    _scaleAnimation = Tween<double>(
      begin: 1.5,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.text,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
