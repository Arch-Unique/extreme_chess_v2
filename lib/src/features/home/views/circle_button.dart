import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  const CircleButton(
      {this.icon = Icons.arrow_back_ios_new_rounded,
      this.color = AppColors.disabledColor,
      this.onPressed,
      super.key});
  final dynamic icon;
  final Color color;
  final Function? onPressed;

  static light({dynamic icon, Function? onPressed}) {
    return CircleButton(
      icon: icon,
      color: AppColors.white,
      onPressed: onPressed,
    );
  }

  static Widget dark({dynamic icon, Function? onPressed}) {
    return CircleButton(
      icon: icon,
      color: AppColors.secondaryColor,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (onPressed != null) {
          await onPressed!();
        }
      },
      customBorder: CircleBorder(),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.disabledColor.withOpacity(0.1)),
        ),
        padding: EdgeInsets.all(16),
        child: Center(
          child: AppIcon(
            icon,
            size: 24 * Ui.mult(context),
            color: color,
          ),
        ),
      ),
    );
  }
}
