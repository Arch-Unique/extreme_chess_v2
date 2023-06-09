import 'package:extreme_chess_v2/src/global/ui/functions/ui_functions.dart';
import 'package:extreme_chess_v2/src/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/home/views/game_screen_animation.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../plugin/chess_board/flutter_chess_board.dart';

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
    controller.setTimeForPlayers(chessBoardController);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryColor,
      body: SafeArea(
        child: Column(
          children: [
            GameHeader(_animation),
            GameHeaderProfile(
              _animation,
              isUser: false,
              isWhite: false,
            ),
            const Spacer(),
            ChessBoard(
              controller: chessBoardController,
              boardOrientation: PlayerColor.white,
            ),
            const Spacer(),
            GameHeaderProfile(
              _animation,
              isUser: true,
              isWhite: true,
            ),
          ],
        ),
      ),
    );
  }
}
