library p5_vector;

import 'dart:math' as math;

import 'package:flutter_p5/constants/constants.dart';

/// `P5Vector` class holds the data for 3 cordinates
/// `x`, `y`, `z` are exposed by this class
class P5Vector {
  num x = 0.0;
  num y = 0.0;
  num z = 0.0;

  P5Vector(num x, num y, [num z = 0.0]) {
    this.x = x;
    this.y = y;
    this.z = z;
  }

  P5Vector setVector({num x = 0.0, num y = 0.0, num z = 0.0}) {
    this.x = x;
    this.y = y;
    this.z = z;

    return this;
  }

  P5Vector mult([num x = 1, num y = 1, num z = 1]) {
    this.x *= x;
    this.y *= y;
    this.z *= z;

    return this;
  }

  P5Vector div([num x = 1, num y = 1, num z = 1]) {
    this.x /= x;
    this.y /= y;
    this.z /= z;

    return this;
  }

  P5Vector add([num x = 0, num y = 0, num z = 0]) {
    this.x += x;
    this.y += y;
    this.z += z;

    return this;
  }

  P5Vector sub([num x = 0, num y = 0, num z = 0]) {
    this.x -= x;
    this.y -= y;
    this.z -= z;

    return this;
  }
}

class P5VectorUtils {
  static P5Vector fromAngle(num angle, [int length = 0]) {
    return new P5Vector(length * math.cos(angle), length * math.sin(angle));
  }

  static P5Vector random2D() {
    return P5VectorUtils.fromAngle(
        math.Random().nextDouble() * P5Constants.TWO_PI);
  }
}
