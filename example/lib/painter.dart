import 'package:flutter/material.dart';
import 'package:flutter_p5/flutter_p5.dart';

class Painter extends StatefulWidget {
  Painter({Key key}) : super(key: key);

  @override
  _PainterState createState() => _PainterState();
}

class _PainterState extends State<Painter> {
  Sketch sketch = Sketch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Painter"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(child: P5Applet(painter: sketch)),
    );
  }
}

class Sketch extends P5Painter {
  var strokes = List<List<P5Vector>>();

  @override
  void setup() {
    fullScreen();

    super.setup();
  }

  @override
  void draw() {
    background(color(0, 0, 0));
    noFill();
    strokeWeight(10);
    stroke(Colors.blueAccent);
    for (var stroke in strokes) {
      beginShape();
      for (var p in stroke) {
        vertex(p.x, p.y);
      }
      endShape();
    }

    super.draw();
  }

  @override
  void pointerPressed() {
    strokes.add([P5Vector(pointerX, pointerY)]);
    super.pointerPressed();
  }

  @override
  void pointerDragged() {
    var stroke = strokes.last;
    stroke.add(new P5Vector(pointerX, pointerY));
    super.pointerDragged();
  }
}
