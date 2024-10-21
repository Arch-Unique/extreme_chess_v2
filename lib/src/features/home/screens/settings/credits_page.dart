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
          headerTile(Iconsax.image_outline, "Images & Icons", Assets.robot, [
            CreditItem("Robot", "https://www.flaticon.com/free-icons/robot",
                icon: Assets.robot),
            CreditItem("Game", "https://www.flaticon.com/free-icons/gaming",
                icon: Assets.console),
            CreditItem(
                "Leaderboard", "https://www.flaticon.com/free-icons/podium",
                icon: Assets.podium),
            CreditItem("Trophy", "https://www.flaticon.com/free-icons/trophy",
                icon: Assets.trophy),
            CreditItem("Chaos", "https://www.flaticon.com/free-icons/devil",
                icon: Assets.easy),
            CreditItem("Mayhem", "https://www.flaticon.com/free-icons/evil",
                icon: Assets.medium),
            CreditItem("Brutal", "https://www.flaticon.com/free-icons/devil",
                icon: Assets.hard),
            CreditItem("World",
                "https://www.freepik.com/free-vector/continents-world-background_16351373.htm",
                icon: Assets.world),
            CreditItem("GIFS", "https://giphy.com",
                icon: "${Assets.winner}1.webp"),
          ]),
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
        AppDivider(),
        headerTile(Iconsax.music_outline, "Music", Assets.robot, [
          CreditItem("Black Knight By Rafael Kruz", "https://www.youtube.com/watch?v=763fSeRXODI",icon: Icons.music_note_rounded),
          CreditItem("Eyes of Glory By Aakash Gandhi", "https://www.youtube.com/watch?v=yTc1Maol2ZA",icon: Icons.music_note_rounded),
          CreditItem("Chariots of War By Aakash Gandhi", "https://www.youtube.com/watch?v=y8kqZ5rmIOA",icon: Icons.music_note_rounded),
          CreditItem("Dragon Castle Epic Battle By Makai Symphony", "https://www.youtube.com/watch?v=82URdJXEZL0",icon: Icons.music_note_rounded),
        ])
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
                    leading: (items[index].icon ?? subIcon) is IconData ? AppIcon(items[index].icon ?? subIcon,size: 16,): Image.asset(
                      items[index].icon ?? subIcon,
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
  final dynamic icon;
  const CreditItem(this.title, this.url, {this.icon});
}
