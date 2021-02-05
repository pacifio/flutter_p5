library p5_widget;

import 'package:flutter/material.dart';
import 'package:flutter_p5/2D/animator.dart';

import 'package:flutter_p5/2D/painter.dart';

/// `P5Applet()` takkes one required argument `P5Painter painter`
/// By default `P5Applet` will take care of all the redrawing and needed animations
class P5Applet extends StatefulWidget {
  final P5Painter painter;
  final Color background;

  final EdgeInsets margin;
  final BorderRadius borderRadius;
  const P5Applet(
      {Key key,
      @required this.painter,
      this.background,
      this.margin,
      this.borderRadius})
      : super(key: key);

  @override
  _P5AppletState createState() => _P5AppletState();
}

class _P5AppletState extends State<P5Applet>
    with SingleTickerProviderStateMixin {
  P5Animator animator;

  @override
  void initState() {
    super.initState();
    animator = P5Animator(this);
    animator.run();

    animator.addListener(() {
      setState(() {
        widget.painter.redraw();
      });
    });
  }

  @override
  void dispose() {
    animator?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.painter.fillParent ? null : widget.painter.width.toDouble(),
      height:
          widget.painter.fillParent ? null : widget.painter.height.toDouble(),
      constraints: widget.painter.fillParent ? BoxConstraints.expand() : null,
      margin: widget.margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.zero,
        child: CustomPaint(
          painter: widget.painter,
          child: GestureDetector(
            onTapUp: (details) {
              widget.painter.onTapUp(context, details);
            },
            onTapDown: (details) {
              widget.painter.onTapDown(context, details);
            },
            onPanStart: (details) {
              widget.painter.onDragStart(context, details);
            },
            onPanUpdate: (details) {
              widget.painter.onDragUpdate(context, details);
            },
            onPanEnd: (details) {
              widget.painter.onDragEnd(context, details);
            },
          ),
        ),
      ),
    );
  }
}
