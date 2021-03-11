import 'package:flutter/material.dart';
import 'package:flutter_p5/flutter_p5.dart';

class ThreeDCube extends StatefulWidget {
  ThreeDCube({Key key}) : super(key: key);

  @override
  _ThreeDCubeState createState() => _ThreeDCubeState();
}

class _ThreeDCubeState extends State<ThreeDCube> {
  Sketch sketch = Sketch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("3D cube"),
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
    box(rotateX: a, rotateY: a);

    a += 1;

    super.draw();
  }
}
