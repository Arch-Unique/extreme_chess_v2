import 'dart:math';

import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/home/controllers/dashboard_controller.dart';
import 'package:extreme_chess_v2/src/home/screens/game_screen.dart';
import 'package:extreme_chess_v2/src/home/views/base_animations.dart';
import 'package:extreme_chess_v2/src/home/views/circle_button.dart';
import 'package:extreme_chess_v2/src/home/views/custom_curve.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../global/ui/ui_barrel.dart';
import '../../src_barrel.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader(this.animation, {super.key});
  final Animation<double> animation;

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.animation,
        builder: (context, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaseAnimationWidget.b2u(
                value: widget.animation.value,
                child: CurvedContainer(
                  padding: EdgeInsets.all(4),
                  color: AppColors.darkTextColor,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.white),
                    padding: EdgeInsets.all(8),
                    child: Image.asset(
                      Assets.trophy,
                      height: 24,
                    ),
                  ),
                ),
              ),
              BaseAnimationWidget.u2b(
                value: widget.animation.value,
                child: CircleButton.dark(icon: Iconsax.menu),
              )
            ],
          );
        });
  }
}

class HomeAction extends StatefulWidget {
  const HomeAction(this.animation, this._homeAction, {super.key});
  final Animation<double> animation;
  final HomeActions _homeAction;

  @override
  State<HomeAction> createState() => _HomeActionState();
}

class _HomeActionState extends State<HomeAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = CurvedAnimation(
        parent: Tween(begin: 0.0, end: 1.0).animate(_controller),
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeOut);

    widget.animation.addStatusListener((status) {
      if (status == AnimationStatus.reverse) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.reset();
    _controller.forward();

    return AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          Widget tor = SizedBox();
          if (widget._homeAction == HomeActions.home) {
            tor = homeAction(Ui.height(context) / 2);
          } else if (widget._homeAction == HomeActions.engine) {
            tor = engineAction();
          }
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseAnimationWidget.b2u(
                  value: _animation.value,
                  child: AppText.bold(widget._homeAction.title,
                      fontSize: 30, color: AppColors.darkTextColor)),
              Ui.boxHeight(24),
              tor,
            ],
          );
        });
  }

  homeAction(double h) {
    return SizedBox(
      height: h,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          BaseAnimationWidget.b2u(
              value: _animation.value - 0.1,
              child: Image.asset(
                Assets.blackChess,
                height: h - 64,
              )),
          Transform.rotate(
            angle: pi / 6,
            child: BaseAnimationWidget.b2u(
                value: _animation.value,
                child: Image.asset(
                  Assets.whiteChess,
                  height: h - 128,
                )),
          )
        ],
      ),
    );
  }

  engineAction() {
    return Column(
      children: [
        ...List.generate(ChessEngines.values.length,
            (index) => engineItem(ChessEngines.values[index]))
      ],
    );
  }

  engineItem(ChessEngines mode) {
    final controller = Get.find<DashboardController>();
    return Ui.padding(
      child: Obx(() {
        return Badge(
          label: CircleAvatar(
            backgroundColor: AppColors.primaryColor,
            radius: 12,
            child: AppIcon(
              Icons.check_rounded,
              color: AppColors.white,
              size: 12,
            ),
          ),
          backgroundColor: AppColors.transparent,
          offset: Offset(0, 0),
          // alignment: AlignmentDirectional.,
          isLabelVisible: mode == controller.selectedChessEngine.value,
          child: CurvedContainer(
            padding: const EdgeInsets.all(16.0),
            onPressed: () {
              controller.selectedChessEngine.value = mode;
              // setState(() {});
            },
            color: AppColors.primaryColor.withOpacity(0.025),
            radius: 16,
            child: Transform.scale(
              scale: _animation.value,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    mode.icon,
                    width: 48,
                  ),
                  Ui.boxHeight(8),
                  AppText.medium(mode.title, color: AppColors.darkTextColor)
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class HomeMenu extends StatefulWidget {
  const HomeMenu(this.animation, {super.key});
  final Animation<double> animation;

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final controller = Get.find<DashboardController>();
  static const angle = -(pi / 25);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    _animation = CurvedAnimation(
        parent: Tween(begin: 0.0, end: 1.0).animate(_controller),
        curve: Curves.elasticOut,
        reverseCurve: Curves.easeOut);

    widget.animation.addStatusListener((status) {
      if (status == AnimationStatus.reverse) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.reset();
    _controller.forward();
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return SizedBox(
            height: 572,
            // width: Ui.width(context) * 0.33,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                    right: -6,
                    top: 0,
                    left: 48,
                    bottom: 360,
                    child: menuItem(HomeActions.engine)),
                // menuItem(HomeActions.leaderboard),r
                Positioned.fill(
                    right: -6,
                    left: 48,
                    top: 360,
                    child: menuItem(HomeActions.leaderboard)),
                Positioned.fill(
                    top: 175,
                    bottom: 185,
                    left: 48,
                    right: -6,
                    child: menuItem(HomeActions.home)),
              ],
            ),
          );
          // return Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     menuItem(HomeActions.engine),
          //     menuItem(HomeActions.home),
          //     menuItem(HomeActions.leaderboard),
          //   ],
          // );
        });
  }

  calcAngle(int i) {
    int a = i - controller.currentHomeAction.value.index;
    return angle * a * _animation.value;
  }

  calcScale(int i) {
    int a = i - controller.currentHomeAction.value.index;
    if (a == 0) {
      return 1.2;
    } else {
      return (widget.animation.value * 0.3) + 0.6;
    }
  }

  Widget menuItem(HomeActions ha) {
    return Transform.scale(
      scale: calcScale(ha.index),
      child: Transform.rotate(
        angle: calcAngle(ha.index),
        child: BaseAnimationWidget.r2l(
            value: widget.animation.value,
            child: Obx(() {
              return CurvedContainer(
                padding: EdgeInsets.all(24),
                onPressed: () {
                  controller.currentHomeAction.value = ha;
                  setState(() {});
                },
                color: ha == controller.currentHomeAction.value
                    ? AppColors.darkTextColor
                    : Color(0xFFFCFCFC),
                radius: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      ha.image,
                      width: 24,
                    ),
                    Ui.boxHeight(16),
                    AppText.thin(ha.desc,
                        color: ha == controller.currentHomeAction.value
                            ? AppColors.textColor
                            : AppColors.darkTextColor),
                    Ui.boxHeight(16),
                    AppButton(
                      onPressed: () {
                        Get.to(GameScreen());
                      },
                      text: ha.btn,
                    )
                  ],
                ),
              );
            })),
      ),
    );
  }
}
