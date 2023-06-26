import 'package:flutter/animation.dart';

class BounceElasticOut extends Curve {
  final double amplitude;
  final double frequency;

  const BounceElasticOut({this.amplitude = 1.0, this.frequency = 1.0});

  @override
  double transform(double t) {
    // Apply bounceOut curve to the initial part of the animation
    if (t < 0.4) {
      return Curves.bounceOut.transform(t / 0.4) * 0.4;
    }

    // Apply elasticOut curve to the rest of the animation
    final double scaledT = (t - 0.4) / 0.6;
    return Curves.elasticOut.transform(scaledT) * 0.6 + 0.4;
  }
}
