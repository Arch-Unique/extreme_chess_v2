import 'package:flutter/material.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

class AppButton extends StatefulWidget {
  final Function? onPressed;
  final Widget? child;
  final String? text, icon;
  final bool? disabled;
  final Color color, borderColor;
  final bool isCircle, isWide, hasBorder;

  AppButton({
    required this.onPressed,
    this.child,
    this.text,
    this.icon,
    this.disabled,
    this.isWide = true,
    this.isCircle = false,
    this.borderColor = AppColors.white,
    this.hasBorder = false,
    this.color = AppColors.primaryColor,
    Key? key,
  }) : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();

  static Widget social(
    Function? onPressed,
    String icon,
  ) {
    return AppButton(
      onPressed: onPressed,
      icon: icon,
      color: AppColors.white,
      isCircle: true,
    );
  }

  static Widget half(
    Function? onPressed,
    String title,
  ) {
    return AppButton(
      onPressed: onPressed,
      text: title,
      isWide: false,
    );
  }

  static Widget white(
    Function? onPressed,
    String title,
  ) {
    return AppButton(
      onPressed: onPressed,
      color: AppColors.white,
      text: title,
    );
  }

  static Widget outline(Function? onPressed, String title,
      {Color color = AppColors.white}) {
    return AppButton(
      onPressed: onPressed,
      hasBorder: true,
      borderColor: AppColors.primaryColor,
      text: title,
      color: color,
    );
  }
}

class _AppButtonState extends State<AppButton> {
  bool disabled = false;
  bool isPressed = false;

  @override
  void initState() {
    disabled = widget.disabled ?? false;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    disabled = widget.disabled ?? false;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: disabled ? AppColors.disabledColor : widget.color,
      elevation: 2,
      shape: widget.isCircle
          ? const CircleBorder()
          : RoundedRectangleBorder(
              borderRadius: Ui.circularRadius(8),
              side: widget.hasBorder
                  ? BorderSide(color: widget.borderColor)
                  : BorderSide.none,
            ),
      onPressed: (disabled || widget.onPressed == null)
          ? null
          : () async {
              if (mounted) {
                setState(() {
                  disabled = true;
                  isPressed = true;
                });
              }
              await widget.onPressed!();

              if (mounted) {
                setState(() {
                  disabled = false;
                  isPressed = false;
                });
              }
            },
      child: widget.isCircle
          ? Container(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                  height: 28,
                  width: 28,
                  child: disabled
                      ? const LoadingIndicator()
                      : Image.asset(widget.icon!)),
            )
          : Container(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
              ),
              width: widget.isWide
                  ? double.maxFinite
                  : (Ui.width(context) / 2) - 36,
              child: Center(
                child: !isPressed
                    ? widget.child ??
                        AppText.button(
                          widget.text!,
                          alignment: TextAlign.center,
                          color: widget.hasBorder
                              ? widget.borderColor
                              : widget.color == AppColors.white
                                  ? AppColors.primaryColor
                                  : AppColors.white,
                        )
                    : const LoadingIndicator(),
              )),
    );
  }
}
