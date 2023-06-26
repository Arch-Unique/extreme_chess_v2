import 'package:cached_network_image/cached_network_image.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:extreme_chess_v2/src/app/app_barrel.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/features/home/screens/game_screen.dart';
import 'package:extreme_chess_v2/src/features/home/screens/online/search_screen.dart';
import 'package:extreme_chess_v2/src/global/ui/functions/ui_functions.dart';
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/button/button.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chess/chess.dart' as chess;

class PlayOnlineEngineScreen extends StatefulWidget {
  const PlayOnlineEngineScreen({super.key});

  @override
  State<PlayOnlineEngineScreen> createState() => _PlayOnlineEngineScreenState();
}

class _PlayOnlineEngineScreenState extends State<PlayOnlineEngineScreen> {
  final controller = Get.find<AppController>();

  @override
  void initState() {
    // TODO: implement initState
    controller.hasAccepted.listen((p0) {
      if (p0) {
        Get.off(GameScreen());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Play Online Engine",
      child: Ui.padding(
          child: ListView.separated(
              itemBuilder: (_, i) {
                if (i == controller.onlineEngines.length) {
                  return AppButton(
                    onPressed: () {
                      if (controller
                          .selectedOnlineEngine.value.username.isEmpty) {
                        Ui.showError("Please choose an engine");
                        return;
                      }
                      controller.playOnlineEngine();
                      showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) {
                            return AlertDialog(
                              title: AppText.bold("Getting game ready"),
                              content: CircularProgress(48),
                            );
                          });
                    },
                    text: "Continue",
                  );
                }
                return Opacity(
                  opacity: controller.onlineEngines[i].isAvailable ? 1 : 0.5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: CachedNetworkImageProvider(
                          controller.onlineEngines[i].image),
                    ),
                    title: AppText.bold(
                        controller.onlineEngines[i].username.capitalizeFirst!,
                        fontSize: 24,
                        color: AppColors.darkTextColor),
                    subtitle: AppText.thin(
                        controller.onlineEngines[i].elo.toString(),
                        color: AppColors.darkTextColor.withOpacity(0.5)),
                    onTap: () {
                      controller.selectedOnlineEngine.value =
                          controller.onlineEngines[i];
                    },
                    trailing: Obx(() {
                      return controller.selectedOnlineEngine.value ==
                              controller.onlineEngines[i]
                          ? AppIcon(
                              Icons.check,
                              color: AppColors.green,
                            )
                          : SizedBox();
                    }),
                  ),
                );
              },
              separatorBuilder: (_, i) {
                return AppDivider();
              },
              itemCount: controller.onlineEngines.length + 1)),
    );
  }
}
