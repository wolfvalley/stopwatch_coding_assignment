import 'dart:math' as math;

double dialValueToRadians(num value) {
  return (value % 60) / 60 * 2 * math.pi;
}