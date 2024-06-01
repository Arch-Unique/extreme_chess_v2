import 'package:extreme_chess_v2/src/features/home/views/circle_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../global/ui/ui_barrel.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget(this.onPressed, {super.key});
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Ui.padding(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton.light(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: () async {
                await onPressed();
              }),
          CircleButton.light(
            icon: Iconsax.menu_outline,
          )
        ],
      ),
    );
  }
}
