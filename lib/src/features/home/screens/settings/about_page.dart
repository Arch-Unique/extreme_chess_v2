import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  final controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "About Us",
      child: Ui.padding(
          child: Column(
        children: [],
      )),
    );
  }
}
