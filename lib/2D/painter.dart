library p5_painter;

import 'dart:typed_data';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_p5/types/arc_types.dart';
import 'package:flutter_p5/constants/constants.dart';

/// Main implementation for the `P5Painter` class
/// This single handedly functions all `2D` drawing operations
///
/// Internally the native flutter's canvas system has been used to paint `2D` shapes
/// A plan for `3D` graphics has been made using the `Texture`
/// Since the engine used by flutter / `Skia` engine is only built for `2D` rendering so possibility to bring in `3D` is low
///
/// `P5Painter` uses `ChangeNotifier` to send notifications to the `P5Animator`
/// to allow the `P5Applet` class to redraw on each `Canvas` update
///
/// Example
/// ```
/// class Sketch extends P5Painter {
///   @override
///   void setup() {
///     size(300, 300);
///     super.setup();
///   }
///
///   @override
///   void draw() {
///     background(color(255, 255, 255));
///     super.draw();
///   }
/// }
/// ```
class P5Painter extends ChangeNotifier implements CustomPainter {
  int width = 100;
  int height = 100;

  bool fillParent = false;

  Canvas canvas;
  Size paintSize;
  Rect canvasRect;

  int frames = 0;

  /// Pointer data START

  double pointerX = 0.0;
  double pointerY = 0.0;

  double prevPointerX = 0.0;
  double prevPointerY = 0.0;

  /// Pointer data END

  Paint backPaint = Paint();
  Paint fillPaint = Paint();
  Paint strokePaint = Paint();
  bool useFill = true;
  bool useStroke = true;

  var vertices = List<Offset>();
  var shapeMode = P5Constants.POLYGON;

  Path path = new Path();

  /// Constructor

  P5Painter() {
    init();
    setup();
    redraw();
  }

  /// Painter logic START

  void redraw() {
    frames++;
    notifyListeners();
  }

  void init() {
    backPaint.style = PaintingStyle.fill;
    backPaint.color = Colors.white;

    fillPaint.style = PaintingStyle.fill;
    fillPaint.color = Colors.white;

    strokePaint.style = PaintingStyle.stroke;
    strokePaint.color = Colors.black;
    strokePaint.strokeCap = StrokeCap.butt;
    strokePaint.strokeJoin = StrokeJoin.bevel;
  }

  /// Painter logic END

  /// Touch handlers START

  /// Used internally by the `P5Painter` class to update the pointer's position
  /// The rest of the functions below has internal purposes to handle touch events
  /// `onTapDown`
  /// `onTapUp`
  /// `onDragStart`
  /// `onDragUpdate`
  /// `onDragEnd`
  void updatePointer(Offset offset) {
    prevPointerX = pointerX;
    pointerX = offset.dx;

    prevPointerY = pointerY;
    pointerY = offset.dy;
  }

  void onTapDown(BuildContext context, TapDownDetails details) {
    final RenderBox box = context.findRenderObject();
    final Offset offset = box.globalToLocal(details.globalPosition);
    updatePointer(offset);
    pointerPressed();
    redraw();
  }

  void onTapUp(BuildContext context, TapUpDetails details) {
    final RenderBox box = context.findRenderObject();
    final Offset offset = box.globalToLocal(details.globalPosition);
    updatePointer(offset);
    pointerReleased();
    redraw();
  }

  void onDragStart(BuildContext context, DragStartDetails details) {
    final RenderBox box = context.findRenderObject();
    final Offset offset = box.globalToLocal(details.globalPosition);
    updatePointer(offset);
    pointerPressed();
    redraw();
  }

  void onDragUpdate(BuildContext context, DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject();
    final Offset offset = box.globalToLocal(details.globalPosition);
    updatePointer(offset);
    pointerDragged();
    redraw();
  }

  void onDragEnd(BuildContext context, DragEndDetails details) {
    pointerReleased();
    redraw();
  }

  /// Must override
  /// This function is called whenever the pointer is released from the screen
  void pointerReleased() {}

  /// Must override
  /// This function is called whenever the pointer is being pressed on the screen
  void pointerPressed() {}

  /// Must override
  /// This function is called whenever the pointer is being dragged from the screen
  void pointerDragged() {}

  /// Touch handlers END

  /// Overrides START
  /// All the required overrides required by the `CustomPainter`

  @override
  bool hitTest(Offset position) => true;

  @override
  void paint(Canvas pcanvas, Size psize) {
    canvas = pcanvas;
    paintSize = psize;
    canvasRect = Offset.zero & paintSize;
    draw();
  }

  @override
  get semanticsBuilder {
    return (Size size) {
      var rect = Offset.zero & size;
      rect = const Alignment(0.0, 0.0).inscribe(size, rect);
      return [
        new CustomPainterSemantics(
          rect: rect,
          properties: new SemanticsProperties(
            label: 'P5 Sketch',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// Overrides END

  /// `draw()` must override by the user in order to draw on the screen
  /// `Processing` functionss must be in order within the drawing method in order to excute perfectly
  ///
  /// It is not required to call `super.draw()` as this functions by default serves no value
  void draw() {}

  /// `setup()` is called to define the structure of the canvas box .
  /// This function is called only once
  void setup() {}

  /// Processing API START

  /// Fills the parent width and height
  void fullScreen() {
    fillParent = true;
  }

  /// Sets the width and the height of the canvas
  void size(int w, int h) {
    width = w;
    height = h;
  }

  /// Define a color by R,G,B, `[A]`
  ///
  /// `color(r,g,b)` can also take only one function that will be a grayscale color
  ///
  /// E.G
  /// ```
  /// color(255, 255, 255) // white
  /// color(255, 0, 0) // red
  /// color(255) // white
  /// ```
  Color color(int r, [int g, int b, double a = 255]) {
    if (g == null && b == null) {
      g = r;
      b = r;
    }
    return Color.fromRGBO(r, g, b, a / 255);
  }

  /// Creates a rect layer on canvas which acts as the background
  void background(Color color) {
    backPaint.color = color;
    canvas.drawRect(canvasRect, backPaint);
  }

  /// Sets the stroke
  void stroke(Color color) {
    strokePaint.color = color;
    useStroke = true;
  }

  /// Sets the stroke weight
  void strokeWeight(double weight) {
    strokePaint.strokeWidth = weight.toDouble();
  }

  /// Sets the stroke cap
  void strokeCap(int cap) {
    if (cap == P5Constants.SQUARE) {
      strokePaint.strokeCap = StrokeCap.butt;
    }
    if (cap == P5Constants.ROUND) {
      strokePaint.strokeCap = StrokeCap.round;
    }
    if (cap == P5Constants.PROJECT) {
      strokePaint.strokeCap = StrokeCap.square;
    }
  }

  /// Sets the stroke join
  void strokeJoin(StrokeJoin join) {
    if (join.index == P5Constants.BEVEL) {
      strokePaint.strokeJoin = StrokeJoin.bevel;
    }
    if (join.index == P5Constants.MITER) {
      strokePaint.strokeJoin = StrokeJoin.miter;
    }
    if (join.index == P5Constants.ROUND) {
      strokePaint.strokeJoin = StrokeJoin.round;
    }
  }

  /// Disables stroke
  void noStroke() {
    useStroke = false;
  }

  /// Enables fill
  void fill(Color color) {
    fillPaint.color = color;
    useFill = true;
  }

  /// Disables fill
  void noFill() {
    useFill = false;
  }

  /// Draws an elippse on the screen
  void ellipse(double x, double y, double w, double h) {
    final rect = new Offset(x - w / 2, y - h / 2) & new Size(w, h);
    if (useFill) {
      canvas.drawOval(rect, fillPaint);
    }
    if (useStroke) {
      canvas.drawOval(rect, strokePaint);
    }
  }

  /// Draws a line on the screen
  void line(double x1, double y1, double x2, double y2) {
    if (useStroke) {
      canvas.drawLine(new Offset(x1, y1), new Offset(x2, y2), strokePaint);
    }
  }

  /// Draws a point on the screen
  void point(double x, double y) {
    if (useStroke) {
      var points = [new Offset(x, y)];
      canvas.drawPoints(PointMode.points, points, strokePaint);
    }
  }

  /// Draws a quad on the screen
  void quad(double x1, double y1, double x2, double y2, double x3, double y3,
      double x4, double y4) {
    beginShape();
    vertex(x1, y1);
    vertex(x2, y2);
    vertex(x3, y3);
    vertex(x4, y4);
    endShape(P5Constants.CLOSE);
  }

  /// Draws a rect on the screen
  void rect(double x, double y, double w, double h) {
    final rect = new Offset(x.toDouble(), y.toDouble()) &
        new Size(w.toDouble(), h.toDouble());
    if (useFill) {
      canvas.drawRect(rect, fillPaint);
    }
    if (useStroke) {
      canvas.drawRect(rect, strokePaint);
    }
  }

  /// Draws a triangle on the screen
  void triangle(
      double x1, double y1, double x2, double y2, double x3, double y3) {
    beginShape();
    vertex(x1, y1);
    vertex(x2, y2);
    vertex(x3, y3);
    endShape();
  }

  /// Clears the `vertices` and sets the shapeMode
  /// Can be passed a shape mode
  /// Default is `3`
  void beginShape([int mode = 3]) {
    shapeMode = mode;
    vertices.clear();
  }

  /// Adds a vertex or a point on the screen
  void vertex(double x, double y) {
    vertices.add(Offset(x.toDouble(), y.toDouble()));
  }

  /// Ends a certain shape
  /// A clear explanation is on the road !
  void endShape([int mode = 0]) {
    if (0 < vertices.length) {
      if (shapeMode == P5Constants.POINTS || shapeMode == P5Constants.LINES) {
        var vlist = List<double>();
        for (var v in vertices) {
          vlist.add(v.dx);
          vlist.add(v.dy);
        }
        var raw = Float32List.fromList(vlist);
        if (shapeMode == P5Constants.POINTS) {
          canvas.drawRawPoints(PointMode.points, raw, strokePaint);
        } else {
          canvas.drawRawPoints(PointMode.lines, raw, strokePaint);
        }
      } else {
        path.reset();
        path.addPolygon(vertices, mode == P5Constants.CLOSE);
        if (useFill) {
          canvas.drawPath(path, fillPaint);
        }
        if (useStroke) {
          canvas.drawPath(path, strokePaint);
        }
      }
    }
  }

  /// Translates the canvas to certain offset
  void translate(double tx, double ty) {
    canvas.translate(tx.toDouble(), ty.toDouble());
  }

  /// Centralizes certain shape by their given width and height
  void center(int w, int h) {
    canvas.translate((paintSize.width - w) * .5, (paintSize.height - h) * .5);
  }

  /// Rotate the canvas
  void rotate(double angle) {
    canvas.rotate((angle * (math.pi / 180)).toDouble());
  }

  /// Scale the whole canvas
  void scale(double sx, double sy) {
    canvas.scale(sx.toDouble(), sy.toDouble());
  }

  /// Saves a copy of the current transform and clip on the save stack. (official dart-doc for canvas.save())
  ///
  /// Please note that it is important to call `push()` as many times as `pop()`
  /// Or it will result in an error !
  void push() {
    canvas.save();
  }

  /// Convert dregress to radians
  double radians(double angle) {
    return (angle / 180) * math.pi;
  }

  /// Convert radians to degress
  double degrees(double angle) {
    return (angle / math.pi) * 180;
  }

  /// Pops the current save stack, if there is anything to pop. Otherwise, does nothing. (official dart-doc for canvas.restore())
  ///
  /// Please note that it is important to call `push()` as many times as `pop()`
  /// Or it will result in an error !
  void pop() {
    canvas.restore();
  }

  /// Displays a text on the canvas
  ///
  /// By default it will render on the center of the canvas
  void text(String text,
      {TextStyle style, TextDirection direction, Offset offset}) {
    final span = TextSpan(
        text: text,
        style: style ?? TextStyle(color: Colors.black, fontSize: 16));
    final textPainter =
        TextPainter(text: span, textDirection: direction ?? TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: paintSize.width);
    textPainter.paint(
        canvas,
        offset ??
            Offset((paintSize.width - textPainter.width) * .5,
                (paintSize.height - textPainter.height) * .5));
  }

  /// Draws an arc on the screen
  ///
  /// `P5ArcType` is set to `P5ArcType.NORMAL` by default
  void arc(
    double x,
    double y,
    double w,
    double h,
    double startAngle,
    double endAngle, {
    P5ArcType arcType = P5ArcType.NORMAL,
  }) {
    Paint paint;

    if (useStroke) {
      paint = strokePaint;
    }

    if (useFill) {
      paint = fillPaint;
    }

    canvas.drawArc(Offset(x, y) & Size(w, h), startAngle,
        (endAngle * (math.pi / 180)), arcType != P5ArcType.NORMAL, paint);
  }

  /// Maps a value by 5 numeric arguments
  /// A better explanation of this function is on the road !
  double map(
      double n, double start1, double stop1, double start2, double stop2) {
    return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2;
  }

  /// Processing API END

  /// Utility API START

  /// Returns the current hour
  int hour() {
    return DateTime.now().hour;
  }

  /// Returns the current minute
  int minute() {
    return DateTime.now().minute;
  }

  /// Returns the current second
  int second() {
    return DateTime.now().second;
  }

  /// Utility API END
}
