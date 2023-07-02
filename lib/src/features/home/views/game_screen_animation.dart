import 'dart:async';

import 'package:chess/chess.dart' hide State;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/others.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/features/home/views/base_animations.dart';
import 'package:extreme_chess_v2/src/features/home/views/header.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class GameHeader extends StatefulWidget {
  const GameHeader(this.animation, this.onPressed, {super.key});
  final Animation<double> animation;
  final Function onPressed;

  @override
  State<GameHeader> createState() => _GameHeaderState();
}

class _GameHeaderState extends State<GameHeader> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animation,
        builder: (_, __) {
          return BaseAnimationWidget.b2u(
              value: widget.animation.value,
              child: HeaderWidget(() async {
                await widget.onPressed();
              }));
        });
  }
}

class GameHeaderProfile extends StatefulWidget {
  const GameHeaderProfile(this.animation,
      {this.isUser = true, this.isWhite = true, super.key});
  final Animation<double> animation;
  final bool isUser, isWhite;

  @override
  State<GameHeaderProfile> createState() => _GameHeaderProfileState();
}

class _GameHeaderProfileState extends State<GameHeaderProfile> {
  final controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animation,
        builder: (_, __) {
          return Padding(
            padding: EdgeInsets.all(24),
            child: ValueListenableBuilder(
                valueListenable: controller.chessController,
                builder: (context, game, _) {
                  return Row(
                    children: [
                      !widget.isUser ? profile() : timer(),
                      const Spacer(),
                      SizedBox(
                        height: 16 * Ui.mult(context),
                        child: Obx(() {
                          if (game.turn == controller.userColor.value &&
                              widget.isUser) {
                            return AppText.thin("Your turn...",
                                fontSize: 14,
                                alignment: TextAlign.center,
                                color: AppColors.white.withOpacity(0.5));
                          } else if (game.turn != controller.userColor.value &&
                              !widget.isUser) {
                            return AppText.thin("Thinking...",
                                fontSize: 14,
                                alignment: TextAlign.center,
                                color: AppColors.white.withOpacity(0.5));
                          } else {
                            return SizedBox();
                          }
                        }),
                      ),
                      const Spacer(),
                      !widget.isUser ? timer() : profile()
                    ],
                  );
                }),
          );
        });
  }

  profile() {
    return CurvedContainer(
      padding: EdgeInsets.all(8),
      radius: 8,
      color: AppColors.white,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          BaseAnimationWidget.r2l(
            value: widget.animation.value,
            child: Transform.scale(
              scale: widget.animation.value,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.white,
                child: ClipOval(
                  child: UniversalImage(
                    widget.isUser
                        ? controller.appRepo.appService.currentUser.value.image
                        : controller.currentOpponent.value.image,
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ),
          ),
          Ui.boxWidth(8),
          BaseAnimationWidget.r2l(
              value: widget.animation.value,
              child: AppText.thin(
                  widget.isUser
                      ? controller.appRepo.appService.currentUser.value.username
                      : controller.currentOpponent.value.username.capitalize!,
                  color: AppColors.darkTextColor)),
        ],
      ),
    );
  }

  timer() {
    return BaseAnimationWidget.r2l(
      value: widget.animation.value,
      child: CurvedContainer(
        color: widget.isUser ? AppColors.primaryColor : AppColors.disabledColor,
        padding: EdgeInsets.all(8),
        radius: 8,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(
              Iconsax.clock,
              color: AppColors.white,
            ),
            Ui.boxWidth(8),
            Obx(() {
              return AppText.bold(
                widget.isWhite
                    ? controller.wTimeString.value
                    : controller.bTimeString.value,
              );
            })
          ],
        ),
      ),
    );
  }
}

class CapturedPieces extends StatefulWidget {
  const CapturedPieces(this.isWhite, {super.key});
  final bool isWhite;

  @override
  State<CapturedPieces> createState() => _CapturedPiecesState();
}

class _CapturedPiecesState extends State<CapturedPieces> {
  final controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: controller.chessController,
        builder: (context, game, _) {
          List<PieceType> a = [];
          if (widget.isWhite) {
            a = controller.chessController.getCapturedWhitePieces(game);
          } else {
            a = controller.chessController.getCapturedBlackPieces(game);
          }
          return SizedBox(
            width: Ui.width(context),
            height: 24 * Ui.mult(context),
            child: Center(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 16),
                  itemCount: a.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) {
                    return capturedPiece(
                        "${widget.isWhite ? "W" : "B"}${a[i].name.toUpperCase()}");
                  }),
            ),
          );
        });
  }

  Widget capturedPiece(String piece) {
    Widget imageToDisplay;
    switch (piece) {
      case "WP":
        imageToDisplay = WhitePawn(
          size: 12,
          fillColor: AppColors.white.withOpacity(0.3),
        );
        break;
      case "WR":
        imageToDisplay = WhiteRook(
          size: 12,
          fillColor: AppColors.white.withOpacity(0.3),
        );
        break;
      case "WN":
        imageToDisplay = WhiteKnight(
          size: 12,
          fillColor: AppColors.white.withOpacity(0.3),
        );
        break;
      case "WB":
        imageToDisplay = WhiteBishop(
          size: 12,
          fillColor: AppColors.white.withOpacity(0.3),
        );
        break;
      case "WQ":
        imageToDisplay = WhiteQueen(
          size: 12,
          fillColor: AppColors.white.withOpacity(0.3),
        );
        break;
      case "WK":
        imageToDisplay = WhiteKing(
          size: 12,
          fillColor: AppColors.white.withOpacity(0.3),
        );
        break;
      case "BP":
        imageToDisplay = BlackPawn(
          fillColor: AppColors.blackPiece.withOpacity(0.3),
          size: 12,
        );
        break;
      case "BR":
        imageToDisplay = BlackRook(
          fillColor: AppColors.blackPiece.withOpacity(0.3),
          size: 12,
        );
        break;
      case "BN":
        imageToDisplay = BlackKnight(
          fillColor: AppColors.blackPiece.withOpacity(0.3),
          size: 12,
        );
        break;
      case "BB":
        imageToDisplay = BlackBishop(
          fillColor: AppColors.blackPiece.withOpacity(0.3),
          size: 12,
        );
        break;
      case "BQ":
        imageToDisplay = BlackQueen(
          fillColor: AppColors.blackPiece.withOpacity(0.3),
          size: 12,
        );
        break;
      case "BK":
        imageToDisplay = BlackKing(
          fillColor: AppColors.blackPiece.withOpacity(0.3),
          size: 12,
        );
        break;
      default:
        imageToDisplay = WhitePawn();
    }
    return imageToDisplay;
  }
}

class AnimatedSearchBackground extends StatefulWidget {
  const AnimatedSearchBackground({super.key});

  @override
  State<AnimatedSearchBackground> createState() =>
      _AnimatedSearchBackgroundState();
}

class _AnimatedSearchBackgroundState extends State<AnimatedSearchBackground> {
  final scrollController = ScrollController();
  double scrollvalue = 0.0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      final offset = scrollvalue * (1300 - Ui.width(context));
      scrollvalue += 0.002;

      scrollController.animateTo(offset,
          duration: Duration(milliseconds: 100), curve: Curves.linear);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: 100,
        itemBuilder: (_, i) {
          return Image.asset(
            Assets.world,
            height: Ui.height(context),
          );
        });
  }
}
