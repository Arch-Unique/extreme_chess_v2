import 'dart:async';

import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/features/home/screens/game_screen.dart';
import 'package:extreme_chess_v2/src/features/home/screens/online/play_online_engine.dart';
import 'package:extreme_chess_v2/src/features/home/views/circle_button.dart';
import 'package:extreme_chess_v2/src/features/home/views/game_screen_animation.dart';
import 'package:extreme_chess_v2/src/features/home/views/home_animations.dart';
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.find<AppController>();

  @override
  void initState() {
    // TODO: implement initState
    controller.waitForNewGame(onSuccess: () {
      Get.off(GameScreen());
    }, onEnd: () {
      Ui.showInfo("No players available, Try again later");
      Get.off(PlayOnlineEngineScreen());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColorBackground,
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          SizedBox(
            height: Ui.height(context),
            width: Ui.width(context),
          ),
          AnimatedSearchBackground(),
          Positioned(
              top: 56,
              left: 24,
              child: CircleButton.dark(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onPressed: () {
                    Get.back();
                  })),
          CurvedContainer(
            padding: EdgeInsets.all(24),
            color: AppColors.secondaryColor.withOpacity(0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.medium("Searching...", fontSize: 20),
                Ui.boxHeight(8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [profileItem(), Ui.boxWidth(24), opponentItem()],
                ),
                Ui.boxHeight(8),
                Obx(() {
                  return AppText.thin(controller.waitTimeString.value,
                      fontSize: 16);
                }),
                Ui.boxHeight(8),
                Obx(() {
                  if (controller.waitTime.value <= 270000) {
                    return SizedBox(
                      width: Ui.width(context) / 2,
                      child: AppButton(
                        onPressed: () {
                          Get.off(PlayOnlineEngineScreen());
                        },
                        text: "Play Engine",
                      ),
                    );
                  }
                  return SizedBox();
                })
              ],
            ),
          ),
          AppText(
            "VS",
            fontSize: 32,
            color: AppColors.red,
            weight: FontWeight.w800,
          ),
        ],
      ),
    );
  }

  Widget profileItem() {
    return CurvedContainer(
      padding: EdgeInsets.all(16),
      color: AppColors.secondaryColor.withOpacity(0.8),
      child: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        radius: 32,
        backgroundImage:
            controller.appRepo.appService.currentUser.value.image.isEmpty
                ? null
                : NetworkImage(
                    controller.appRepo.appService.currentUser.value.image),
      ),
    );
  }

  Widget opponentItem() {
    return CurvedContainer(
      padding: EdgeInsets.all(16),
      color: AppColors.secondaryColor.withOpacity(0.8),
      child: CircleAvatar(
        backgroundColor: AppColors.primaryColor,
        radius: 32,
        child: AnimatedOpponent(),
      ),
    );
  }

  @override
  dispose() {
    controller.cancelNewGame();
    super.dispose();
  }
}
