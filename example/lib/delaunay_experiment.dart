// Inspired by -> https://openprocessing.org/sketch/413567

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_p5/flutter_p5.dart';
import 'package:delaunay/delaunay.dart';

final maxLevel = 5;

class DelaunayExperiment extends StatefulWidget {
  DelaunayExperiment({Key key}) : super(key: key);

  @override
  _DelaunayExperimentState createState() => _DelaunayExperimentState();
}

class _DelaunayExperimentState extends State<DelaunayExperiment> {
  Sketch sketch = Sketch();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Delaunay experiment"),
        elevation: 0.0,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete), onPressed: () => sketch.clear())
        ],
      ),
      body: Center(child: P5Applet(painter: sketch)),
    );
  }
}

class Sketch extends P5Painter {
  List<Particle> particles = [];
  Delaunay delaunay;

  @override
  void setup() {
    fullScreen();

    super.setup();
  }

  void clear() {
    particles.clear();
  }

  @override
  void draw() {
    background(color(0));

    for (var i = particles.length - 1; i > -1; i--) {
      particles[i].move(particles);
    }

    if (particles.length > 0) {
      List<double> cords = [];

      particles.forEach((element) {
        cords.add(element.x.toDouble());
        cords.add(element.y.toDouble());
      });

      delaunay = Delaunay(Float32List.fromList(cords));
      delaunay.update();

      for (var i = 0; i < delaunay.triangles.length; i += 3) {
        var p1 = particles[delaunay.triangles[i]];
        var p2 = particles[delaunay.triangles[i + 1]];
        var p3 = particles[delaunay.triangles[i + 2]];

        var distThresh = 75;

        if (dist(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y) > distThresh) {
          continue;
        }

        if (dist(p2.pos.x, p2.pos.y, p3.pos.x, p3.pos.y) > distThresh) {
          continue;
        }

        if (dist(p1.pos.x, p1.pos.y, p3.pos.x, p3.pos.y) > distThresh) {
          continue;
        }

        noFill();
        stroke(color((165 * (p1.life * 3)), (165 * (p2.life * 2)),
            (165 * (p3.life * 1))));

        triangle(p1.pos.x, p1.pos.y, p2.pos.x, p2.pos.y, p3.pos.x, p3.pos.y);
      }
    }

    super.draw();
  }

  @override
  void pointerDragged() {
    particles.add(
        Particle(x: pointerX, y: pointerY, level: maxLevel, painter: this));

    super.pointerDragged();
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
    this.vel = this.vel.mult(
        this.painter.map(this.level.toDouble(), 0, maxLevel.toDouble(), 5, 2));
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
