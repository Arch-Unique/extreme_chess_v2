import 'package:flutter/material.dart';
import '/src/app/app_barrel.dart';

class CircleDot extends StatelessWidget {
  final Color color;
  final double size;

  const CircleDot({
    Key? key,
    this.color = AppColors.primaryColor,
    this.size = 16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.darkTextColor,
      radius: size - 1,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: color,
      ),
    );
  }
}
