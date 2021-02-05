# example

## P5 clock example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_p5/flutter_p5.dart';

class P5Clock extends StatefulWidget {
  P5Clock({Key key}) : super(key: key);

  @override
  _P5ClockState createState() => _P5ClockState();
}

class _P5ClockState extends State<P5Clock> {
  Sketch sketch = Sketch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("P5 Example"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(child: P5Applet(painter: sketch)),
    );
  }
}

class Sketch extends P5Painter {
  @override
  void setup() {
    size(300, 300);

    super.setup();
  }

  @override
  void draw() {
    background(Colors.black);
    translate(0, 300);
    rotate(-90);

    var hr = hour();
    var mn = minute();
    var sc = second();

    strokeWeight(8);
    noFill();

    stroke(color(255, 100, 150));
    var secondAngle = map(sc.toDouble(), 0, 60, 0, 360);
    arc(50, 50, 200, 200, 0, secondAngle);

    stroke(color(150, 100, 255));
    var minuteAngle = map(mn.toDouble(), 0, 60, 0, 360);
    arc(60, 60, 180, 180, 0, minuteAngle);

    stroke(color(150, 255, 100));
    var hourAngle = map((hr % 12).toDouble(), 0, 24, 0, 360);
    arc(70, 70, 160, 160, 0, hourAngle);

    translate(300, 0);

    rotate(90);
    text(
        "${(hr % 12).toString().padLeft(2, '0')}:$mn:${sc.toString().padLeft(2, '0')}",
        style: TextStyle(color: Colors.white, fontSize: 20));

    super.draw();
  }
}
```
