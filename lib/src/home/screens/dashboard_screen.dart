import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/home/controllers/dashboard_controller.dart';
import 'package:extreme_chess_v2/src/home/views/home_animations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final controller = Get.find<DashboardController>();

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

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Ui.padding(child: HomeHeader(_animation)),
            Ui.boxHeight(24),
            Expanded(
                child: Row(
              children: [
                Expanded(child: Ui.padding(
                  child: Obx(() {
                    return HomeAction(
                        _animation, controller.currentHomeAction.value);
                  }),
                )),
                Expanded(
                    child: Column(
                  children: [
                    HomeMenu(_animation),
                  ],
                ))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
