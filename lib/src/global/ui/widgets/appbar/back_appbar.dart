import 'package:extreme_chess_v2/src/features/home/views/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

AppBar backAppBar(BuildContext context,
    {String? title,
    Widget? titleWidget,
    Color color = AppColors.darkTextColor,
    bool hasBack = true,
    List<Widget>? trailing}) {
  return AppBar(
      backgroundColor: AppColors.white,
      title: title == null
          ? titleWidget
          : AppText.medium(title, fontSize: 24, color: color),
      elevation: 0,
      actions: trailing ?? [],
      toolbarHeight: 104 * Ui.mult(context),
      // centerTitle: true,
      leadingWidth: hasBack ? 104 * Ui.mult(context) : 28,
      leading: hasBack
          ? Padding(
              padding: EdgeInsets.only(
                  left: 0,
                  top: 24 * Ui.mult(context),
                  bottom: 24 * Ui.mult(context)),
              child: CircleButton.dark(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onPressed: () async {
                    Get.back();
                  }))
          : SizedBox());
}
