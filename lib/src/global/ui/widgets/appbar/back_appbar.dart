import 'package:extreme_chess_v2/src/home/views/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/app/app_barrel.dart';
import '/src/global/ui/ui_barrel.dart';

AppBar backAppBar(
    {String? title,
    Widget? titleWidget,
    Color color = AppColors.textColor,
    bool hasBack = true,
    List<Widget>? trailing}) {
  return AppBar(
      toolbarHeight: 96,
      backgroundColor: AppColors.white,
      title: title == null
          ? titleWidget
          : AppText.medium(title, fontSize: 24, color: color),
      elevation: 0,
      actions: trailing ?? [],
      leadingWidth: hasBack ? 56 : 28,
      leading: hasBack
          ? CircleButton.light(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: () async {
                Get.back();
              })
          : SizedBox());
}
