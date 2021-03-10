import 'package:flutter/material.dart';
import 'package:flutter_p5/flutter_p5.dart';

class Stars extends StatefulWidget {
  Stars({Key key}) : super(key: key);

  @override
  _StarsState createState() => _StarsState();
}

class _StarsState extends State<Stars> {
  Sketch sketch = Sketch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Stars"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(child: P5Applet(painter: sketch)),
    );
  }
}

class Sketch extends P5Painter {
  List<Star> stars = [];

  @override
  void setup() {
    fullScreen();

    stars = List.generate(
        800,
        (index) => Star(
              p5painter: this,
            ));

    super.setup();
  }

  @override
  void draw() {
    background(color(0));
    translate(375, 667);

    for (var i = 0; i < stars.length; i++) {
      stars[i].update();
      stars[i].show();
    }

    super.draw();
  }
}

class Star {
  double x, y, z, pz;
  P5Painter painter;

  final int width = 375;
  final int height = 667;

  Star({
    @required P5Painter p5painter,
  }) {
    painter = p5painter;

    x = painter.randomDouble(-width, width);
    y = painter.randomDouble(-height, height);
    z = painter.randomDouble(0, width);
    pz = z;
  }

  void update() {
    this.z = this.z - 8;
    if (this.z < 1) {
      this.z = width.toDouble();
      this.x = painter.randomDouble(-width, width);
      this.y = painter.randomDouble(-height, height);
      this.pz = this.z;
    }
  }

  void show() {
    painter.fill(painter.color(255));
    painter.noStroke();

    var sx = painter.map(this.x / this.z, 0, 1, 0, width.toDouble());
    var sy = painter.map(this.y / this.z, 0, 1, 0, height.toDouble());
    var r = painter.map(this.z, 0, width.toDouble(), 16, 0);
    painter.ellipse(sx, sy, r, r);

    var px = painter.map(this.x / this.pz, 0, 1, 0, width.toDouble());
    var py = painter.map(this.y / this.pz, 0, 1, 0, height.toDouble());

    this.pz = this.z;

    painter.stroke(painter.color(255));
    painter.line(px, py, sx, sy);
  }
}
