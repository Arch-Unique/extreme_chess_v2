import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:extreme_chess_v2/src/features/home/screens/leaderboard_screen.dart';
import 'package:extreme_chess_v2/src/features/home/screens/online/create_game_screen.dart';
import 'package:extreme_chess_v2/src/features/home/screens/online/search_screen.dart';
import 'package:extreme_chess_v2/src/global/controller/connection_controller.dart';
import 'package:extreme_chess_v2/src/global/model/user.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/features/home/screens/game_screen.dart';
import 'package:extreme_chess_v2/src/features/home/screens/settings/about_page.dart';
import 'package:extreme_chess_v2/src/features/home/screens/settings/contributor_page.dart';
import 'package:extreme_chess_v2/src/features/home/screens/settings/credits_page.dart';
import 'package:extreme_chess_v2/src/features/home/screens/settings/donation_page.dart';
import 'package:extreme_chess_v2/src/features/home/screens/settings/instruction_page.dart';
import 'package:extreme_chess_v2/src/features/home/screens/settings/mystats_page.dart';
import 'package:extreme_chess_v2/src/features/home/views/base_animations.dart';
import 'package:extreme_chess_v2/src/features/home/views/circle_button.dart';
import 'package:extreme_chess_v2/src/features/home/views/custom_curve.dart';
import 'package:extreme_chess_v2/src/utils/constants/prefs/prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../global/ui/ui_barrel.dart';
import '../../../src_barrel.dart';
import 'package:chess/chess.dart' as chess;

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
                  onPressed: () {
                    Get.to(MyStatsScreen());
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.white),
                    padding: EdgeInsets.all(8 * Ui.mult(context)),
                    child: Image.asset(
                      Assets.trophy,
                      height: 24 * Ui.mult(context),
                    ),
                  ),
                ),
              ),
              BaseAnimationWidget.u2b(
                value: widget.animation.value,
                child: CircleButton.dark(
                    icon: Iconsax.menu_outline,
                    onPressed: () {
                      _showSettings();
                    }),
              )
            ],
          );
        });
  }

  Future _showSettings() async {
    final controller = Get.find<AppController>();
    final screens = [
      MyStatsScreen(),
      ContributorScreen(),
      InstructionScreen(),
      // AboutScreen(),
      CreditsScreen(),
      DonationScreen()
    ];
    final screenTitle = [
      "My Stats",
      "Contributors",
      "Instructions",
      // "About Us",
      "Credits",
      "Donate"
    ];

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.bold("Settings",
                    fontSize: 24, color: AppColors.darkTextColor),
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: AppIcon(
                      Icons.close,
                      color: AppColors.darkTextColor,
                    ))
              ],
            ),
            content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: AppText.medium("Player Color:",
                        color: AppColors.darkTextColor),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() {
                          return CurvedContainer(
                            padding: EdgeInsets.all(8),
                            child: WhiteKing(
                              size: 24,
                            ),
                            color:
                                controller.userColor.value == chess.Color.WHITE
                                    ? AppColors.primaryColor
                                    : AppColors.transparent,
                            onPressed: () {
                              controller.userColor.value = chess.Color.WHITE;
                            },
                          );
                        }),
                        Ui.boxWidth(16),
                        Obx(() {
                          return CurvedContainer(
                            padding: EdgeInsets.all(8),
                            color:
                                controller.userColor.value != chess.Color.WHITE
                                    ? AppColors.primaryColor
                                    : AppColors.transparent,
                            onPressed: () {
                              controller.userColor.value = chess.Color.BLACK;
                            },
                            child: BlackKing(
                              size: 24,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  Ui.boxHeight(8),
                  ...List.generate(
                      screenTitle.length,
                      (index) => ListTile(
                            onTap: () {
                              Get.to(screens[index]);
                            },
                            title: AppText.medium(screenTitle[index],
                                color: AppColors.darkTextColor),
                            trailing: AppIcon(Icons.arrow_forward_ios_rounded,
                                color: AppColors.darkTextColor, size: 16),
                          )),
                  Ui.boxHeight(8),
                  Obx(() {
                    return controller.appRepo.appService.isLoggedIn.value
                        ? AppButton.outline(() async {
                            await controller.appRepo.appService.logout();
                          }, "Logout")
                        : AppButton(
                            onPressed: () async {
                              await controller.appRepo
                                  .loginSocial(ThirdPartyTypes.google);
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Brand(
                                    Brands.google,
                                    size: 24,
                                  ),
                                  Ui.boxWidth(24),
                                  AppText.button("Login with Google")
                                ]),
                          );
                  })
                ]));
      },
    );
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
  List<AvailableUser> robots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllRobots();
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

  Future getAllRobots() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    final appController = Get.find<AppController>();

    robots = await appController.appRepo.getRobots();
    appController.onlineEngines = robots;

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
          } else {
            tor = leaderboardAction();
          }
          return Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseAnimationWidget.b2u(
                  value: _animation.value,
                  child: AppText.bold(widget._homeAction.title,
                      fontSize: 28, color: AppColors.darkTextColor)),
              Ui.boxHeight(24),
              tor,
            ],
          );
        });
  }

  homeAction(double h) {
    return GestureDetector(
      onLongPress: () {
        _showGMArena();
      },
      child: SizedBox(
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
      ),
    );
  }

  leaderboardAction() {
    final connectionController = Get.find<ConnectionController>();
    return Obx(() {
      return connectionController.isConnected.value
          ? !isLoading
              ? robots.isEmpty
                  ? AppButton(
                      onPressed: () async {
                        await getAllRobots();
                      },
                      text: "Refresh",
                    )
                  : Column(
                      children: [
                        ...List.generate(
                            robots.length,
                            (index) => BaseAnimationWidget.l2r(
                                value: _animation.value,
                                child: Opacity(
                                    opacity: (0.1 * (robots.length - index))
                                        .clamp(0.0, 1.0),
                                    child: onlineEngineItem(robots[index]))))
                      ],
                    )
              : AppText.thin("Loading...", color: AppColors.disabledColor)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIcon(
                  Icons.wifi_rounded,
                  color: AppColors.disabledColor,
                  size: 64,
                ),
                Ui.boxHeight(24),
                AppText.thin("No Network Detected",
                    color: AppColors.disabledColor)
              ],
            );
    });
  }

  engineAction() {
    return Column(
      children: [
        ...List.generate(ChessEngines.values.length,
            (index) => engineItem(ChessEngines.values[index]))
      ],
    );
  }

  Widget onlineEngineItem(AvailableUser user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: CachedNetworkImageProvider(user.image),
          ),
          Ui.boxWidth(4),
          AppText.thin(user.username.capitalizeFirst!,
              color: AppColors.darkTextColor),
          const Spacer(),
          AppText.bold(user.elo.toString(),
              // fontFamily: "Roboto",
              fontSize: 16,
              color: AppColors.darkTextColor.withOpacity(0.5)),
        ],
      ),
    );
  }

  engineItem(ChessEngines mode) {
    final controller = Get.find<AppController>();
    return Ui.padding(
      padding: 16,
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
              controller.currentOpponent.value =
                  User(username: mode.title, image: mode.icon, elo: mode.elo);
              // setState(() {});
            },
            onLongPressed: () {
              _showEngineInfo(mode);
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
                    width: 56*Ui.mult(context),
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

  Future _showGMArena() async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFFC0C0C0),
            title: AppText.bold("GrandMaster Arena",
                fontSize: 20, color: AppColors.darkTextColor),
            content: AppText.thin('''
In the midst of this captivating realm,
Emerges the grand challenge at the helm.
Once victorious over the engines mighty,
The gateway to Online Mode shines brightly.

Becoming a Grandmaster, a momentous feat,
Conquer Chaos, Mayhem, or Brutal, complete.
With this triumph, the title is bestowed,
Grandmaster status, your skills proudly showed.

Enter the Online Mode, a worldwide stage,
Face off against Grandmasters, undeterred by age.
Engage in battles of wit and cerebral might,
Where strategies clash and champions ignite.

Rest assured, your opponents are elite,
Having conquered the engines, they're hard to beat.
If no rivals are found on this grand endeavor,
Choose from ten open source engines, just as clever.

Stockfish and companions, masters of their kind,
Offering limitless expertise, a true chess mastermind.
These additional features enhance the thrill,
With unrivaled challenges and skills to fulfill.

In this grand arena where intellect thrives,
The chess world mesmerized, passion revived.
From the intro to the conclusion, it's clear,
Chess engines reign supreme, forever held dear.
''', color: AppColors.darkTextColor),
          );
        });
  }

  Future _showEngineInfo(ChessEngines mode) async {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: mode.color,
          title: AppText.bold(mode.title,
              fontSize: 20, color: AppColors.darkTextColor),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 120,
                child: BouncingEngineWidget(
                  child: Image.asset(
                    mode.icon,
                    width: 48,
                  ),
                ),
              ),
              Ui.boxHeight(8),
              AppText.medium(mode.desc, color: AppColors.darkTextColor)
            ],
          ),
        );
      },
    );
  }
}

class TypewriterScreen extends StatefulWidget {
  final String text;
  const TypewriterScreen(this.text, {super.key});

  @override
  State<TypewriterScreen> createState() => _TypewriterScreenState();
}

class _TypewriterScreenState extends State<TypewriterScreen> {
  Timer? _timer;
  int _currentIndex = 0;
  String _text = "";
  Duration _delay = Duration(milliseconds: 100);

  @override
  void initState() {
    _text = widget.text;
    super.initState();
    _startTypewriter();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTypewriter() {
    _timer = Timer.periodic(_delay, (timer) {
      if (_currentIndex < _text.length) {
        setState(() {
          _currentIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String displayedText = _text.substring(0, _currentIndex);

    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _timer as Animation<double>,
          builder: (context, child) {
            return AppText.medium(displayedText,
                color: AppColors.darkTextColor);
          },
        ),
      ),
    );
  }
}

class HomeMenu extends StatefulWidget {
  const HomeMenu(this.animation, this.onReverse, {super.key});
  final Animation<double> animation;
  final Function onReverse;

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final controller = Get.find<AppController>();
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
          // return SizedBox(
          //   height: 572,
          //   // width: Ui.width(context) * 0.33,
          //   child: Stack(
          //     clipBehavior: Clip.none,
          //     children: [
          //       Positioned.fill(
          //           right: -6,
          //           top: 0,
          //           left: 48,
          //           bottom: 360,
          //           child: menuItem(HomeActions.engine)),
          //       // menuItem(HomeActions.leaderboard),r
          //       Positioned.fill(
          //           right: -6,
          //           left: 48,
          //           top: 360,
          //           child: menuItem(HomeActions.leaderboard)),
          //       Positioned.fill(
          //           top: 175,
          //           bottom: 185,
          //           left: 48,
          //           right: -6,
          //           child: menuItem(HomeActions.home)),
          //     ],
          //   ),
          // );
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              menuItem(HomeActions.engine),
              menuItem(HomeActions.home),
              menuItem(HomeActions.leaderboard),
            ],
          );
        });
  }

  calcAngle(int i) {
    int a = i - controller.currentHomeAction.value.index;
    return angle * a * _animation.value;
  }

  calcScale(int i) {
    int a = i - controller.currentHomeAction.value.index;
    if (a == 0) {
      return 1.0;
    } else {
      return (widget.animation.value * 0.3) + 0.5;
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
                padding: EdgeInsets.only(top: 24,bottom: 24,left: 12,right: 8),
                onPressed: () {
                  controller.currentHomeAction.value = ha;
                  setState(() {});
                },
                color: ha == controller.currentHomeAction.value
                    ? AppColors.darkTextColor
                    : Color(0xFFFCFCFC),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      ha.image,
                      width: 24,
                    ),
                    Ui.boxHeight(8),
                    AppText.thin(ha.desc,
                        color: ha == controller.currentHomeAction.value
                            ? AppColors.textColor
                            : AppColors.darkTextColor),
                    Ui.boxHeight(8),
                    AppButton(
                      onPressed: () async {
                        if (ha.index == 0) {
                          // widget.onReverse();
                          Get.to(GameScreen());
                        } else if (ha.index == 1) {
                          // Get.to(CreateOnlineGameScreen());
                          if (controller.appRepo.appService.isLoggedIn.value) {
                            if (controller
                                    .appRepo.appService.currentUser.value.elo ==
                                0) {
                              print("i am here 00000");
                              Ui.showInfo(
                                  "You've not yet beaten any of the 3 engines");
                            } else {
                              //TODO

                              controller.setupSocketGame();
                              Get.to(CreateOnlineGameScreen());
                            }
                          } else {
                            Ui.showError("Please Sign In to continue");
                          }
                        } else {
                          Get.to(LeaderBoardScreen());
                          // controller.reInitStockFish();
                          // Ui.showInfo(
                          //     "Coming Soon, Try beating any of the engines");
                        }
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

class AnimatedOpponent extends StatefulWidget {
  const AnimatedOpponent({super.key});

  @override
  State<AnimatedOpponent> createState() => _AnimatedOpponentState();
}

class _AnimatedOpponentState extends State<AnimatedOpponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Color color = AppColors.primaryColor;

  @override
  void initState() {
    // TODO: implement
    print("moving opponent");

    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 8000),
        upperBound: Colors.accents.length - 1)
      ..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller.view,
        builder: (_, __) {
          return Transform.scale(
            scale: _controller.value,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: Colors.accents[_controller.value.floor()],
              child: AppIcon(
                Iconsax.profile_circle_outline,
                size: 48,
              ),
            ),
          );
        });
  }
}
