import 'package:flutter/material.dart';

class BaseAnimationWidget extends StatelessWidget {
  const BaseAnimationWidget(
      {required this.child,
      this.animation,
      this.isVertical = false,
      this.isHorizontal = false,
      this.isForward = false,
      this.space = 48,
      super.key});
  final double? animation;
  final Widget child;
  final double space;
  final bool isVertical;
  final bool isHorizontal;
  final bool isForward;

  @override
  Widget build(BuildContext context) {
    // return child;
    return animation == null
        ? child
        : Opacity(
            opacity: animation!.clamp(0.0, 1.0),
            child: Transform.translate(
              offset: Offset(calcOffset(true), calcOffset(false)),
              child: child,
            ));
  }

  double calcOffset(bool isX) {
    if (isVertical && !isHorizontal && !isX) {
      return (isForward ? (1 - animation!) : -(1 - animation!)) * space;
    } else if (isHorizontal && !isVertical && isX) {
      return (isForward ? (1 - animation!) : -(1 - animation!)) * space;
    } else {
      return 0;
    }
  }

  static l2r({required double value, required Widget child}) {
    return BaseAnimationWidget(
      animation: value,
      isHorizontal: true,
      isForward: true,
      child: child,
    );
  }

  static Widget r2l({required double value, required Widget child}) {
    return BaseAnimationWidget(
      animation: value,
      isHorizontal: true,
      isForward: false,
      child: child,
    );
  }

  static u2b({required double value, required Widget child}) {
    return BaseAnimationWidget(
      animation: value,
      isVertical: true,
      isForward: true,
      child: child,
    );
  }

  static b2u({required double value, required Widget child}) {
    return BaseAnimationWidget(
      animation: value,
      isVertical: true,
      isForward: false,
      child: child,
    );
  }
}
