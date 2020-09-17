import 'package:flutter/material.dart';

class FadeIn extends StatefulWidget {
  final Widget child;
  final double delay;
  final Duration duration;
  FadeIn({@required this.child, this.delay = 100, this.duration});
  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: widget.duration ??
            Duration(milliseconds: (600 + widget.delay).toInt()));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
