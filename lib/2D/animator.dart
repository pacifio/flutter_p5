library p5_animator;

import 'package:flutter/material.dart';

/// `P5Animator` is an internal class to redraw on every canvas update
/// Used internally by the `P5Applet` widget to call `setState` whenever an update is needed
/// Do not use externally
class P5Animator extends AnimationController {
  P5Animator(TickerProvider v)
      : super.unbounded(
            duration: const Duration(milliseconds: 2000), vsync: v) {
    addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        reverse();
      } else if (status == AnimationStatus.dismissed) {
        forward();
      }
    });
  }

  void run() {
    forward();
  }
}
