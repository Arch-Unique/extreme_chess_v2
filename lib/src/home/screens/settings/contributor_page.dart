import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContributorScreen extends StatelessWidget {
  ContributorScreen({super.key});

  final controller = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Contributors",
      child: Ui.padding(
          child: Column(
        children: [],
      )),
    );
  }
}
