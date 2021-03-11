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
        title: Text("Menger Sponge"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(child: P5Applet(painter: sketch)),
    );
  }
}

class Sketch extends P5Painter {
  double a = 0.0;

  @override
  void setup() {
    size(300, 300);

    super.setup();
  }

  @override
  void draw() {
    background(Colors.black);
    stroke(color(255));
    box(rotateX: -a);

    a += .5;

    super.draw();
  }
}

class Box {
  P5Vector pos;
  double r;
  P5Painter painter;

  Box({double x, double y, double z, double r, @required this.painter}) {
    this.pos = P5Vector(x, y, z);
    this.r = r;
  }

  void show() {
    this.painter.push();
  }
}
