import 'package:chess/chess.dart' hide State;
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/others.dart';
import 'package:extreme_chess_v2/src/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/home/views/base_animations.dart';
import 'package:extreme_chess_v2/src/home/views/header.dart';
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
            padding: EdgeInsets.symmetric(
                horizontal: 24, vertical: widget.isUser ? 24.0 : 0.0),
            child: ValueListenableBuilder(
                valueListenable: controller.chessController,
                builder: (context, game, _) {
                  return Column(
                    children: [
                      if (widget.isUser)
                        SizedBox(
                          height: 16,
                          child: Obx(() {
                            return game.turn == controller.userColor.value
                                ? AppText.thin("Your turn...",
                                    fontSize: 14,
                                    alignment: TextAlign.center,
                                    color: AppColors.white.withOpacity(0.5))
                                : SizedBox();
                          }),
                        ),
                      if (widget.isUser) Ui.boxHeight(16),
                      Row(
                        children: [
                          !widget.isUser ? profile() : timer(),
                          const Spacer(),
                          !widget.isUser ? timer() : profile()
                        ],
                      ),
                      if (!widget.isUser) Ui.boxHeight(16),
                      if (!widget.isUser)
                        SizedBox(
                          height: 16,
                          child: Obx(() {
                            return game.turn == controller.userColor.value
                                ? SizedBox()
                                : AppText.thin(
                                    "${controller.currentOpponent.value.firstName} is thinking...",
                                    fontSize: 14,
                                    alignment: TextAlign.center,
                                    color: AppColors.white.withOpacity(0.5));
                          }),
                        )
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
              child: widget.isUser
                  ? AppIcon(
                      Iconsax.profile_circle,
                      color: AppColors.primaryColor,
                      size: 24,
                    )
                  : UniversalImage(
                      controller.currentOpponent.value.image,
                      height: 24,
                      width: 24,
                    ),
            ),
          ),
          Ui.boxWidth(8),
          BaseAnimationWidget.r2l(
              value: widget.animation.value,
              child: AppText.thin(
                  widget.isUser
                      ? controller.currentUser.value.fullName
                      : controller.currentOpponent.value.fullName,
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
              return AppText.medium(
                  widget.isWhite
                      ? controller.wTimeString.value
                      : controller.bTimeString.value,
                  fontFamily: "Roboto");
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
            height: 24,
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
