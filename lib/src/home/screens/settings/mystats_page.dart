import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyStatsScreen extends StatefulWidget {
  const MyStatsScreen({super.key});

  @override
  State<MyStatsScreen> createState() => _MyStatsScreenState();
}

class _MyStatsScreenState extends State<MyStatsScreen> {
  final controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "My Stats",
      child: Ui.padding(
          child: Column(
        children: [
          AppText.medium(controller.currentUser.value.fullName,
              fontSize: 24, color: AppColors.darkTextColor),
          Ui.boxHeight(8),
          AppText.thin("Not ranked",
              color: AppColors.disabledColor.withOpacity(0.5)),
          Ui.boxHeight(8),
          AppDivider(),
          Ui.boxHeight(8),
          Ui.boxHeight(8),
          AppDivider(),
          Ui.boxHeight(8),
        ],
      )),
    );
  }
}
