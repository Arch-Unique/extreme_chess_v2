import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
          headerTile(Iconsax.music, "Music", Assets.robot, []),
          AppDivider(),
          headerTile(Iconsax.picture_frame, "Icons", Assets.robot, []),
          AppDivider(),
          headerTile(Iconsax.image, "Images", Assets.robot, []),
          AppDivider(),
          headerTile(Icons.computer, "Engines", Assets.robot, const [
            CreditItem(
                "StockFish", "https://github.com/official-stockfish/Stockfish"),
            CreditItem("Berserk", "https://github.com/jhonnold/berserk"),
            CreditItem("RubiChess", "https://github.com/Matthies/RubiChess"),
            CreditItem("Koivisto", "https://github.com/Luecx/Koivisto"),
            CreditItem("Igel", "https://github.com/vshcherbyna/igel"),
            CreditItem("Seer", "https://github.com/connormcmonigle/seer-nnue"),
            CreditItem("Clover", "https://github.com/lucametehau/CloverEngine"),
            CreditItem(
                "Viridithas", "https://github.com/cosmobobak/viridithas"),
            CreditItem("Minic", "https://github.com/tryingsomestuff/Minic"),
            CreditItem("Velvet", "https://github.com/mhonert/velvet-chess"),
          ]),
        ],
      )),
    );
  }

  headerTile(
      dynamic icon, String title, String subIcon, List<CreditItem> items) {
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
                    onTap: () {
                      launchUrl(Uri.parse(items[index].url));
                    },
                    contentPadding: EdgeInsets.only(left: 32),
                    leading: Image.asset(
                      subIcon,
                      height: 16,
                    ),
                    title: AppText.thin(items[index].title,
                        color: AppColors.darkTextColor.withOpacity(0.5)),
                    subtitle: AppText.thin(items[index].url,
                        fontSize: 14,
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
