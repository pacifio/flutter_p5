library p5_vector;

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
}
