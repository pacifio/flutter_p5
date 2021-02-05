library p5_constants;

/// `P5Constants` helps in identifying 2D shapes
/// meant for internal usage only
class P5Constants {
  static const int OPEN = 0;
  static const int CLOSE = 1;

  static const int LINES = 1;
  static const int POINTS = 2;
  static const int POLYGON = 3;

  static const int SQUARE = 1 << 0;
  static const int ROUND = 1 << 1;
  static const int PROJECT = 1 << 2;

  static const int MITER = 1 << 3;
  static const int BEVEL = 1 << 5;
}
