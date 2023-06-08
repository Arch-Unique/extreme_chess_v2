import 'package:flutter/material.dart';
import 'dart:math' as math;

/// This is the main class, you should only use this Widget to
/// create your custom Animated Icon
class AnimateIcons extends StatefulWidget {
  /// Default constructor
  const AnimateIcons({
    Key? key,
    required this.startIcon,
    required this.endIcon,
    required this.controller,
    required this.onStartIconPress,
    required this.onEndIconPress,
    this.size = 24.0,
    this.duration = const Duration(milliseconds: 1000),
    this.curve = Curves.easeInOut,
    this.clockwise = true,
    this.startIconColor,
    this.endIconColor,
    this.amplitude = 180.0,
    this.splashRadius,
    this.splashColor = Colors.transparent,
    this.startTooltip,
    this.endTooltip,
  }) : super(key: key);

  /// The Icon that will be visible before animation starts
  final IconData startIcon;

  /// The Icon that will be visible after animation ends
  final IconData endIcon;

  /// The controller for the animations
  final AnimateIconController controller;

  /// The callback on startIcon Press
  ///
  /// If `true` is returned it will animate to the end icon
  /// if `false` is returned it won't animate to the end icon
  final bool Function() onStartIconPress;

  /// The callback on endIcon Press
  ///
  /// If `true` is returned it will animate to the starting icon
  /// if `false` is returned it won't animate to the starting icon
  final bool Function() onEndIconPress;

  /// The size of the icons.
  ///
  /// Defaults to 24.0
  final double size;

  /// The duration of the animation
  final Duration duration;

  /// The curve for the animation
  ///
  /// Default is Curves.easeInOut
  final Curve curve;

  /// Whether the animation runs in the clockwise or anticlockwise direction
  final bool clockwise;

  /// The color to be used for the [startIcon]
  final Color? startIconColor;

  /// The color to be used for the [endIcon]
  final Color? endIconColor;

  /// The amplitude of the rotation animation in degrees
  ///
  /// Defaults to 180
  final double amplitude;

  /// This is the radius of the splash around the Icon, will be colored with [splashColor].
  final double? splashRadius;

  /// This is the Color for the splash around the Icon, will be [splashRadius] wide.
  ///
  /// Defaults to Colors.transparent
  final Color splashColor;

  /// This is the tooltip that will be used for the [startIcon]
  final String? startTooltip;

  /// This is the tooltip that will be used for the [endIcon]
  final String? endTooltip;

  @override
  _AnimateIconsState createState() => _AnimateIconsState();
}

class _AnimateIconsState extends State<AnimateIcons>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.clockwise ? widget.curve : widget.curve.flipped,
      ),
    );
    _initControllers();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _initControllers() {
    widget.controller.animateToEnd = () {
      if (mounted) {
        _controller.forward();
        return true;
      } else {
        return false;
      }
    };
    widget.controller.animateToStart = () {
      if (mounted) {
        _controller.reverse();
        return true;
      } else {
        return false;
      }
    };
    widget.controller.isStart = () => _animation.value == 0.0;
    widget.controller.isEnd = () => _animation.value == 1.0;
  }

  _onStartIconPress() {
    if (widget.onStartIconPress() && mounted) _controller.forward();
  }

  _onEndIconPress() {
    if (widget.onEndIconPress() && mounted) _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    double x = _animation.value;
    double y = 1.0 - _animation.value;
    double opacityX = x >= 0 && x <= 1.0 ? x : _controller.value;
    double opacityY = y >= 0 && y <= 1.0 ? y : (1 - _controller.value);
    double angleX = math.pi / 180 * (widget.amplitude * x);
    double angleY = math.pi / 180 * (widget.amplitude * y);

    Widget _first() {
      final icon = Icon(widget.startIcon, size: widget.size);
      return Transform.rotate(
        angle: widget.clockwise ? angleX : -angleX,
        child: Opacity(
          opacity: opacityY,
          child: IconButton(
            splashColor: widget.splashColor,
            splashRadius: widget.splashRadius,
            iconSize: widget.size,
            color: widget.startIconColor ?? Theme.of(context).primaryColor,
            disabledColor: Colors.grey.shade500,
            icon: widget.startTooltip == null
                ? icon
                : Tooltip(
                    message: widget.startTooltip!,
                    child: icon,
                  ),
            onPressed: _onStartIconPress,
          ),
        ),
      );
    }

    Widget _second() {
      final icon = Icon(widget.endIcon);
      return Transform.rotate(
        angle: widget.clockwise ? -angleY : angleY,
        child: Opacity(
          opacity: opacityX,
          child: IconButton(
            splashColor: widget.splashColor,
            splashRadius: widget.splashRadius,
            iconSize: widget.size,
            color: widget.endIconColor ?? Theme.of(context).primaryColor,
            disabledColor: Colors.grey.shade500,
            icon: widget.endTooltip == null
                ? icon
                : Tooltip(
                    message: widget.endTooltip!,
                    child: icon,
                  ),
            onPressed: _onEndIconPress,
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        x == 1 && y == 0 ? _second() : _first(),
        x == 0 && y == 1 ? _first() : _second(),
      ],
    );
  }
}

/// This is a sub-controller for the icons' animations
class AnimateIconController {
  /// This is the function to run the animation backwards
  late bool Function() animateToStart;

  /// This is the function to run the animation forward
  late bool Function() animateToEnd;

  /// This is a simple getter to know if the animation status is at its starting point
  late bool Function() isStart;

  /// This is a simple getter to know if the animation status is at its ending point
  late bool Function() isEnd;
}
