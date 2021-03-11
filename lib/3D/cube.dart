/// Inspired from
/// https://github.com/pothonprogramming/pothonprogramming.github.io/blob/master/content/cube/cube.html

import 'dart:math' as math;
import 'package:flutter_p5/math/vector.dart';

class Cube {
  double x;
  double y;
  double z;
  double size;
  List<P5Vector> vertices;
  List<List> faces;

  Cube({double x, double y, double z, double size}) {
    P5Vector(x, y, z);

    size *= .5;

    this.x = x;
    this.y = y;
    this.z = z;
    this.size = size;

    this.vertices = [
      P5Vector(x - size, y - size, z - size),
      P5Vector(x + size, y - size, z - size),
      P5Vector(x + size, y + size, z - size),
      P5Vector(x - size, y + size, z - size),
      P5Vector(x - size, y - size, z + size),
      P5Vector(x + size, y - size, z + size),
      P5Vector(x + size, y + size, z + size),
      P5Vector(x - size, y + size, z + size)
    ];

    this.faces = [
      [0, 1, 2, 3],
      [0, 4, 5, 1],
      [1, 5, 6, 2],
      [3, 2, 6, 7],
      [0, 3, 7, 4],
      [4, 7, 6, 5]
    ];
  }

  rotateX(double radian) {
    var cosine = math.cos(radian);
    var sine = math.sin(radian);

    for (var i = this.vertices.length - 1; i > -1; --i) {
      P5Vector p = this.vertices[i];
      var _y = (p.y - this.y) * cosine - (p.z - this.z) * sine;
      var _z = (p.y - this.y) * sine + (p.z - this.z) * cosine;

      p.y = _y + this.y;
      p.z = _z + this.z;
    }
  }

  void rotateY(double radian) {
    var cosine = math.cos(radian);
    var sine = math.sin(radian);

    for (var i = this.vertices.length - 1; i > -1; --i) {
      P5Vector p = this.vertices[i];
      var _x = (p.z - this.z) * sine + (p.x - this.x) * cosine;
      var _z = (p.z - this.z) * cosine - (p.x - this.x) * sine;

      p.x = _x + this.x;
      p.z = _z + this.z;
    }
  }
}
