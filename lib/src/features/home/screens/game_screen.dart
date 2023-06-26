import 'package:extreme_chess_v2/src/global/ui/functions/ui_functions.dart';
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/features/home/views/game_screen_animation.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../plugin/chess_board/flutter_chess_board.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  ChessBoardController chessBoardController = ChessBoardController();
  final controller = Get.find<AppController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = CurvedAnimation(
        parent: Tween(begin: 0.0, end: 1.0).animate(_controller),
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeOut);

    _controller.forward();
    controller.setChessBoardController(chessBoardController);
    if (controller.isOfflineMode.value) {
      controller.setTimeForPlayers();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    controller.exitGame();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final a = await _showAboutToLeave();
        controller.exitGame();
        return a;
      },
      child: Scaffold(
        backgroundColor: AppColors.secondaryColor,
        body: SafeArea(
          child: Column(
            children: [
              GameHeader(_animation, () async {
                final a = await _showAboutToLeave();
                if (a) {
                  controller.exitGame();
                  Get.back();
                }
              }),
              const Spacer(),
              Obx(() {
                return GameHeaderProfile(
                  _animation,
                  isUser: false,
                  isWhite: controller.userColor.value != Color.WHITE,
                );
              }),
              Ui.boxHeight(16),
              Obx(() {
                return CapturedPieces(
                    controller.userColor.value == Color.WHITE);
              }),
              const Spacer(),
              Obx(() {
                return ChessBoard(
                  controller: chessBoardController,
                  boardOrientation: controller.userColor.value == Color.WHITE
                      ? PlayerColor.white
                      : PlayerColor.black,
                );
              }),
              const Spacer(),
              Obx(() {
                return CapturedPieces(
                    controller.userColor.value != Color.WHITE);
              }),
              Ui.boxHeight(16),
              Obx(() {
                return GameHeaderProfile(
                  _animation,
                  isUser: true,
                  isWhite: controller.userColor.value == Color.WHITE,
                );
              }),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showAboutToLeave() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            title: AppText.bold("Exiting the game",
                fontSize: 24, color: AppColors.darkTextColor),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.medium("Are you sure you want to exit the game ?",
                      color: AppColors.darkTextColor),
                  Ui.boxHeight(24),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.back(result: true);
                          },
                          child: AppText.button("Yes",
                              color: AppColors.darkTextColor)),
                      Ui.boxWidth(24),
                      TextButton(
                          onPressed: () {
                            Get.back(result: false);
                          },
                          child: AppText.button("No",
                              color: AppColors.darkTextColor)),
                    ],
                  ),
                ]));
      },
    ).then((value) {
      return value ?? false;
    });
  }
}
