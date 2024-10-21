import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class MyStatsScreen extends StatefulWidget {
  const MyStatsScreen({super.key});

  @override
  State<MyStatsScreen> createState() => _MyStatsScreenState();
}

class _MyStatsScreenState extends State<MyStatsScreen> {
  final controller = Get.find<AppController>();
  int curSel = 0;
  List<String> modeTitles = ["OFFLINE", "ONLINE"];

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "My Stats",
      child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Obx(() {
                return CircleAvatar(
                  radius: Ui.width(context) / 6,
                  backgroundColor: AppColors.white,
                  backgroundImage: controller
                          .appRepo.appService.currentUser.value.image.isEmpty
                      ? null
                      : NetworkImage(controller
                          .appRepo.appService.currentUser.value.image),
                  child: controller
                          .appRepo.appService.currentUser.value.image.isEmpty
                      ? AppIcon(
                          Iconsax.profile_circle_outline,
                          size: Ui.width(context) / 3,
                          color: AppColors.darkTextColor,
                        )
                      : null,
                );
              }),
              Ui.boxHeight(8),
              Obx(() {
                return AppText.medium(
                    controller.appRepo.appService.currentUser.value.username,
                    fontSize: 24,
                    color: AppColors.darkTextColor);
              }),
              Ui.boxHeight(8),
              AppText.thin(
                  controller.appRepo.appService.currentUser.value.elo == 0
                      ? "Not ranked"
                      : controller.appRepo.appService.currentUser.value.elo
                          .toString(),
                  color: AppColors.disabledColor.withOpacity(0.5)),
              Ui.boxHeight(8),
              Divider(
                color: AppColors.disabledColor,
              ),
              // Ui.boxHeight(8),
              Row(
                children: [modeSwitcherItem(0), modeSwitcherItem(1)],
              ),
              // Ui.boxHeight(8),
              Divider(
                color: AppColors.disabledColor,
              ),
              Ui.boxHeight(8),
              curSel == 0 ? offlinePage() : onlinePage()
            ],
          )),
    );
  }

  modeSwitcherItem(int b) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            curSel = b;
          });
        },
        child: AppText.thin(modeTitles[b],
            fontSize: 32,
            color: curSel == b
                ? AppColors.darkTextColor
                : AppColors.darkTextColor.withOpacity(0.3),
            alignment: TextAlign.center),
      ),
    );
  }

  onlinePage() {
    return Obx(() {
      if (controller.appRepo.appService.currentUser.value.elo == 0) {
        return Column(
          // mainAxisSize: ,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Ui.boxHeight(32),
            AppText.medium(
                "Beat any of the three engines first before you can access your online profile, but if you have done so, press refresh below",
                fontSize: 20,
                color: AppColors.darkTextColor),
            Ui.boxHeight(24),
            AppButton(
              onPressed: () async {
                await controller.appRepo.appService.refreshUser();
              },
              text: "Refresh",
            )
          ],
        );
      } else {
        int totalGames = controller.appRepo.appService.currentUser.value.wins +
            controller.appRepo.appService.currentUser.value.draws +
            controller.appRepo.appService.currentUser.value.losses;
        totalGames = totalGames == 0 ? 1 : totalGames;
        double wr =
            controller.appRepo.appService.currentUser.value.wins / totalGames;
        int wrp = (wr * 100).round();
        String winrate = "$wrp%";
        Color wincolor = ColorTween(begin: AppColors.red, end: AppColors.green)
            .transform(wr)!;
        final winTitles = ["Wins", "Draws", "Losses"];
        final winNum = [
          controller.appRepo.appService.currentUser.value.wins,
          controller.appRepo.appService.currentUser.value.draws,
          controller.appRepo.appService.currentUser.value.losses,
        ];

        return Column(
          children: [
            Ui.boxHeight(32),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    3,
                    (index) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText.bold(winTitles[index],
                                color: AppColors.darkTextColor, fontSize: 24),
                            Ui.boxHeight(8),
                            AppText.thin(winNum[index].toString(),
                                color: AppColors.darkTextColor, fontSize: 32)
                          ],
                        ))),
            Ui.boxHeight(32),
            AppText.bold(
              winrate,
              fontSize: 48,
              color: wincolor,
            ),
            Ui.boxHeight(4),
            AppText.thin("Win Rate", color: AppColors.darkTextColor)
          ],
        );
      }
    });
  }

  offlinePage() {
    final mp = controller.appRepo.appService.userEngineStats();

    int totalGames = mp.values
        .toList()
        .map((e) => e.reduce((value, element) => value + element))
        .reduce((value, element) => value + element);
    totalGames = totalGames == 0 ? 1 : totalGames;
    int wins =
        mp.values.map((e) => e[0]).reduce((value, element) => value + element);
    double wr = wins / totalGames;
    int wrp = (wr * 100).round();
    String winrate = "$wrp%";
    Color wincolor =
        ColorTween(begin: AppColors.red, end: AppColors.green).transform(wr)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Table(
          columnWidths: {
            0: FractionColumnWidth(0.4),
            1: FractionColumnWidth(0.2),
            2: FractionColumnWidth(0.2),
            3: FractionColumnWidth(0.2),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(children: [
              AppText.medium("Engines", color: AppColors.darkTextColor),
              AppText.medium("Wins",
                  color: AppColors.darkTextColor, alignment: TextAlign.center),
              AppText.medium("Draws",
                  color: AppColors.darkTextColor, alignment: TextAlign.center),
              AppText.medium("Losses",
                  color: AppColors.darkTextColor, alignment: TextAlign.center),
            ]),
            ...List.generate(mp.length, (index) {
              final mpEntry = mp.entries.toList()[index];
              return TableRow(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        mpEntry.key.icon,
                        width: 24,
                      ),
                      Ui.boxWidth(8),
                      AppText.bold(mpEntry.key.title,
                          color: AppColors.darkTextColor, fontSize: 20),
                    ],
                  ),
                ),
                AppText.thin(mpEntry.value[0].toString(),
                    color: AppColors.darkTextColor,
                    alignment: TextAlign.center),
                AppText.thin(mpEntry.value[1].toString(),
                    color: AppColors.darkTextColor,
                    alignment: TextAlign.center),
                AppText.thin(mpEntry.value[2].toString(),
                    color: AppColors.darkTextColor,
                    alignment: TextAlign.center),
              ]);
            })
          ],
        ),
        Ui.boxHeight(16),
        AppText.bold(
          winrate,
          fontSize: 48,
          color: wincolor,
        ),
        Ui.boxHeight(4),
        AppText.thin("Win Rate", color: AppColors.darkTextColor)
      ],
    );
  }
}
