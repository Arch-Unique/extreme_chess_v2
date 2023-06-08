import 'package:extreme_chess_v2/src/global/model/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';

import '../../../../src_barrel.dart';

class CurvedContainer extends StatefulWidget {
  final Widget? child;
  final double radius;
  final double? width, height;
  final String? image;
  final Color color;
  final Border? border;
  final bool shouldClip;
  final VoidCallback? onPressed;
  final EdgeInsets? margin, padding;
  const CurvedContainer(
      {this.child,
      this.radius = 8,
      this.height,
      this.width,
      this.onPressed,
      this.margin,
      this.padding,
      this.border,
      this.image,
      this.shouldClip = true,
      this.color = AppColors.accentColor,
      super.key});

  @override
  State<CurvedContainer> createState() => _CurvedContainerState();
}

class _CurvedContainerState extends State<CurvedContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _sizeAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTap() {
    if (widget.onPressed != null) {
      widget.onPressed!();
    }
    _animationController.reverse();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTapDown: widget.onPressed == null ? null : _handleTapDown,
        onTapUp: widget.onPressed == null ? null : _handleTapUp,
        onTap: widget.onPressed == null ? null : _handleTap,
        onTapCancel: widget.onPressed == null
            ? null
            : () {
                _animationController.reverse();
              },
        child: AnimatedBuilder(
          animation: _sizeAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _sizeAnimation.value,
              child: child,
            );
          },
          child: AnimatedContainer(
            width: widget.width,
            height: widget.height,
            margin: widget.margin,
            // onEnd: () {
            //   setState(() {
            //     scaleFactor = _sizeAnimation.value;
            //   });
            // },

            clipBehavior: widget.shouldClip ? Clip.hardEdge : Clip.none,
            padding: widget.padding,
            decoration: BoxDecoration(
                borderRadius: Ui.circularRadius(widget.radius),
                color: widget.color,
                border: widget.border,
                image: widget.image == null
                    ? null
                    : DecorationImage(
                        image: AssetImage(widget.image!), fit: BoxFit.fill)),
            duration: Duration(milliseconds: 300),
            child: widget.child,
          ),
        ));
  }
}

class SinglePageScaffold extends StatelessWidget {
  final String? title;
  final Widget? child;
  final bool safeArea;
  const SinglePageScaffold(
      {this.title, this.child, this.safeArea = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: backAppBar(title: title),
      body: safeArea ? SafeArea(child: child!) : child,
    );
  }
}

class SizedText extends StatelessWidget {
  final Widget? child;
  final double space;
  const SizedText({this.child, this.space = 48, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Ui.width(context) - space,
      child: child,
    );
  }

  static thin(String text, {double space = 48}) {
    return SizedText(
      child: AppText.thin(text),
      space: space,
    );
  }
}

class CurvedImage extends StatelessWidget {
  const CurvedImage(this.url,
      {this.w = 240, this.radius = 16, this.fit, this.h, super.key});
  final double radius, w;
  final double? h;
  final BoxFit? fit;
  final String url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: UniversalImage(
          url,
          width: w,
          height: h,
          fit: fit,
        ));
  }
}

class SvgIconButton extends StatelessWidget {
  final double size;
  final Color color;
  final String url;
  final VoidCallback onTap;
  final double padding;
  const SvgIconButton(this.url, this.onTap,
      {this.size = 24,
      this.color = AppColors.white,
      this.padding = 8,
      super.key});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: (size + 16) / 2,
      customBorder: CircleBorder(),
      child: SizedBox(
        height: size + 8,
        width: size + 8,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: SvgPicture.asset(
            url,
            height: size,
            width: size,
            color: color,
          ),
        ),
      ),
    );
  }
}

class LoadingErrorWidget extends StatefulWidget {
  const LoadingErrorWidget(
      {required this.loadingWidget,
      required this.successWidget,
      this.loadingFunc,
      this.loadingController,
      super.key});
  final Function? loadingFunc;
  final Rx<Loading>? loadingController;
  final Widget loadingWidget, successWidget;

  @override
  State<LoadingErrorWidget> createState() => _LoadingErrorWidgetState();
}

class _LoadingErrorWidgetState extends State<LoadingErrorWidget> {
  Rx<Loading> loading = Loading(isLoading: true).obs;

  @override
  void initState() {
    loading = widget.loadingController ?? loading;
    onFuncCalled();
    super.initState();
  }

  Future<void> onFuncCalled() async {
    if (mounted) {
      loading.value.isLoading = true;
      loading.refresh();
      if (widget.loadingFunc != null) {
        try {
          await widget.loadingFunc!();
          loading.value.hasError = false;
        } catch (e) {
          loading.value.hasError = true;
        }
      }
      loading.value.isLoading = false;
      loading.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return loading.value.loadedWithError
          ? CurvedContainer(
              margin: EdgeInsets.all(24),
              radius: 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ErrorPage(
                    hasBg: false,
                  ),
                  Ui.boxHeight(48),
                  AppButton(
                    onPressed: () async {
                      await onFuncCalled();
                    },
                    text: "Retry",
                  )
                ],
              ),
            )
          : loading.value.isLoading
              ? widget.loadingWidget
              : widget.successWidget;
    });
  }
}
