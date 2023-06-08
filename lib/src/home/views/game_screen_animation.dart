import 'package:chess/chess.dart' hide State;
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/others.dart';
import 'package:extreme_chess_v2/src/home/controllers/dashboard_controller.dart';
import 'package:extreme_chess_v2/src/home/views/base_animations.dart';
import 'package:extreme_chess_v2/src/home/views/header.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

class GameHeader extends StatefulWidget {
  const GameHeader(this.animation, {super.key});
  final Animation<double> animation;

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
              value: widget.animation.value, child: HeaderWidget(() {}));
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
  final controller = Get.find<DashboardController>();
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animation,
        builder: (_, __) {
          return Ui.padding(
            child: Row(
              children: [
                !widget.isUser ? profile() : timer(),
                const Spacer(),
                !widget.isUser ? timer() : profile()
              ],
            ),
          );
        });
  }

  profile() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BaseAnimationWidget.r2l(
          value: widget.animation.value,
          child: Transform.scale(
            scale: widget.animation.value,
            child: CircleAvatar(),
          ),
        ),
        Ui.boxWidth(24),
        BaseAnimationWidget.r2l(
            value: widget.animation.value, child: AppText.thin("Sullivan")),
      ],
    );
  }

  timer() {
    return BaseAnimationWidget.r2l(
      value: widget.animation.value,
      child: CurvedContainer(
        color: widget.isUser ? AppColors.primaryColor : AppColors.disabledColor,
        padding: EdgeInsets.all(8),
        radius: 24,
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
