import 'package:flutter/material.dart';
import 'package:flutter_p5/flutter_p5.dart';

class MengerSponge extends StatefulWidget {
  MengerSponge({Key key}) : super(key: key);

  @override
  _MengerSpongeState createState() => _MengerSpongeState();
}

class _MengerSpongeState extends State<MengerSponge> {
  Sketch sketch = Sketch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Menger Sponge"),
            const SizedBox(
              height: 4,
            ),
            Text(
              "This doesn't work properly as fill API not working",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
            ),
          ],
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(child: P5Applet(painter: sketch)),
    );
  }
}

class Sketch extends P5Painter {
  Box b;
  double a = 0.0;
  List<Box> sponge = [];

  @override
  void setup() {
    size(375, 400);
    Box b = Box(painter: this, x: 0, y: 0, z: 300);
    sponge.add(b);
    super.setup();
  }

  @override
  void draw() {
    background(Colors.black);
    stroke(color(255));

    for (var b in sponge) {
      b.show(a);
    }

    a += 0.5;

    super.draw();
  }

  @override
  void pointerPressed() {
    List<Box> next = [];

    for (var b in sponge) {
      List<Box> newBoxes = b.generate();
      next.addAll(newBoxes);
    }

    sponge = next;

    super.pointerPressed();
  }
}

class Box {
  P5Vector pos;
  P5Painter painter;

  final double r = 50;

  Box({double x, double y, double z, @required this.painter}) {
    this.pos = P5Vector(x, y, z);
  }

  List<Box> generate() {
    List<Box> boxes = [];
    for (int x = -1; x < 2; x++) {
      for (int y = -1; y < 2; y++) {
        for (int z = -1; z < 2; z++) {
          int sum = x.abs() + y.abs() + z.abs();
          double newR = this.r / 3;
          if (sum > 1) {
            Box b = Box(
                x: pos.x + x * newR,
                y: pos.y + y * newR,
                z: pos.z + z * newR,
                painter: this.painter);
            boxes.add(b);
          }
        }
      }
    }

    return boxes;
  }

  void show([double a = 0.0]) {
    this.painter.push();
    this.painter.translate(pos.x, pos.y);
    this.painter.box(
        x: this.pos.x, y: this.pos.y, z: this.pos.z, rotateX: a, rotateY: a);
    this.painter.pop();
  }
}
