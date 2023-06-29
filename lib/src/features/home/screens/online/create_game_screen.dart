import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:extreme_chess_v2/src/app/app_barrel.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/features/home/screens/online/play_online_engine.dart';
import 'package:extreme_chess_v2/src/features/home/screens/online/search_screen.dart';
import 'package:extreme_chess_v2/src/global/ui/functions/ui_functions.dart';
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/button/button.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chess/chess.dart' as chess;

class CreateOnlineGameScreen extends StatefulWidget {
  const CreateOnlineGameScreen({super.key});

  @override
  State<CreateOnlineGameScreen> createState() => _CreateOnlineGameScreenState();
}

class _CreateOnlineGameScreenState extends State<CreateOnlineGameScreen> {
  final controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Create New Game",
      child: Ui.padding(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() {
                  return CurvedContainer(
                    padding: EdgeInsets.all(16),
                    child: WhiteKing(
                      size: 56,
                    ),
                    color: controller.userColor.value == chess.Color.WHITE
                        ? AppColors.primaryColor
                        : AppColors.transparent,
                    onPressed: () {
                      controller.userColor.value = chess.Color.WHITE;
                    },
                  );
                }),
                Obx(() {
                  return CurvedContainer(
                    padding: EdgeInsets.all(16),
                    color: controller.userColor.value != chess.Color.WHITE
                        ? AppColors.primaryColor
                        : AppColors.transparent,
                    onPressed: () {
                      controller.userColor.value = chess.Color.BLACK;
                    },
                    child: BlackKing(
                      size: 56,
                    ),
                  );
                }),
              ],
            ),
            Ui.boxHeight(32),
            AppText.bold("5mins", color: AppColors.darkTextColor, fontSize: 24),
            Ui.boxHeight(24),
            // Expanded(child: ListView.)
            Ui.boxHeight(24),
            AppButton(
              onPressed: () {
                controller.createOnlineGame();
                Get.to(SearchScreen());
              },
              text: "Continue",
            ),
            Ui.boxHeight(24),

            AppText.bold("OR", color: AppColors.darkTextColor.withOpacity(0.5)),
            Ui.boxHeight(24),
            AppButton.outline(() {
              Get.to(PlayOnlineEngineScreen());
            }, "Play Online Engine", color: AppColors.white)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.appRepo.apiService.socket.disconnect();
    super.dispose();
  }
}
