import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class ContributorScreen extends StatelessWidget {
  ContributorScreen({super.key});

  final controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
        title: "Contributors",
        child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (_, i) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.white,
                  child: AppIcon(
                    Iconsax.programming_arrow,
                    color: AppColors.darkTextColor,
                  ),
                ),
                title: AppText.bold("@Arch-Unique",
                    fontSize: 20, color: AppColors.darkTextColor),
                subtitle: AppText.thin(
                  "https://github.com/Arch-Unique",
                  color: AppColors.primaryColor,
                ),
              );
            },
            separatorBuilder: (_, i) {
              return Divider(
                color: AppColors.disabledColor.withOpacity(0.5),
              );
            },
            itemCount: 2));
  }
}
