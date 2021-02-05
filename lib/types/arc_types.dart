library p5_arctype;

/// Arc types for the `arc()` function
/// Simply after passing all the required arguments for the `arc()` function
/// Use `arc(arcType:P5ArcTupe)` to use the Arc type
/// `P5ArcType` has 2 values
/// `P5ArcType.NORMAL` and `P5ArcType.PIE`
///
/// The normal one will result in a normal arc
/// The pie one will result in a pie like shaped arc
enum P5ArcType {
  NORMAL,
  PIE,
}
