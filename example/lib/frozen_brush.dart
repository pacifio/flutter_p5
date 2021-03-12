// Inspired by -> https://openprocessing.org/sketch/413567

import 'package:flutter/material.dart';
import 'package:flutter_p5/flutter_p5.dart';

class FrozenBrush extends StatefulWidget {
  FrozenBrush({Key key}) : super(key: key);

  @override
  _FrozenBrushState createState() => _FrozenBrushState();
}

class _FrozenBrushState extends State<FrozenBrush> {
  Sketch sketch = Sketch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Frozen brush"),
        elevation: 0.0,
        centerTitle: true,
      ),
      body: Center(child: P5Applet(painter: sketch)),
    );
  }
}

class Sketch extends P5Painter {
  List<Particle> particles;

  @override
  void setup() {
    fullScreen();
    background(color(0));
    super.setup();
  }

  @override
  void draw() {
    noStroke();
    fill(color(0));
    rect(0, 0, width.toDouble(), height.toDouble());

    for (var i = particles.length - 1; i > -1; i--) {
      particles[i].move(particles);
    }

    super.draw();
  }
}

class Particle {
  num x;
  num y;
  num level;
  num life;
  P5Vector pos;
  P5Vector vel;
  P5Painter painter;

  final maxLevel = 5;

  Particle(
      {@required num x,
      @required num y,
      @required num level,
      @required P5Painter painter}) {
    this.x = x;
    this.y = y;
    this.life = 0;
    this.level = level;
    this.painter = painter;
    this.pos = P5Vector(this.x, this.y);
    this.vel = P5VectorUtils.random2D();
    this.vel.mult(this.painter.map(this.level, 0, maxLevel.toDouble(), 5, 2));
  }

  void move(List<Particle> particles) {
    this.life++;
    this.vel.mult(0.9);
    this.pos.add(this.vel.x, this.vel.y);

    if ((this.life % 10) == 0) {
      if (this.level > 0) {
        this.level -= 1;
        particles.add(Particle(
            x: this.x,
            y: this.y,
            level: this.level - 1,
            painter: this.painter));
      }
    }
  }
}
