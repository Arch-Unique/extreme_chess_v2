import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class CreditsScreen extends StatelessWidget {
  CreditsScreen({super.key});

  final controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Credits",
      child: SingleChildScrollView(
          child: Column(
        children: [
          headerTile(Iconsax.music, "Music", []),
          AppDivider(),
          headerTile(Iconsax.picture_frame, "Icons", []),
          AppDivider(),
          headerTile(Iconsax.image, "Images", []),
          AppDivider(),
          headerTile(Icons.computer, "Plugins", []),
        ],
      )),
    );
  }

  headerTile(dynamic icon, String title, List<CreditItem> items) {
    return Column(
      children: [
        ListTile(
          leading: AppIcon(
            icon,
            color: AppColors.primaryColor,
          ),
          contentPadding: EdgeInsets.only(left: 32),
          title: AppText.medium(title,
              fontSize: 24, color: AppColors.darkTextColor),
        ),
        if (items.isNotEmpty)
          ...List.generate(
              items.length,
              (index) => ListTile(
                    dense: true,
                    title: AppText.thin(items[index].title,
                        color: AppColors.darkTextColor.withOpacity(0.5)),
                    subtitle: AppText.thin(items[index].url,
                        color: AppColors.primaryColor.withOpacity(0.5)),
                  ))
      ],
    );
  }
}

class CreditItem {
  final String title, url;
  const CreditItem(this.title, this.url);
}
