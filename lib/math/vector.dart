library p5_vector;

/// `P5Vector` class holds the data for 3 cordinates
/// `x`, `y`, `z` are exposed by this class
class P5Vector {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  P5Vector(double x, double y, [double z = 0.0]) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
}
