import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color primaryColorBackground = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFF9542FF);
  static const Color secondaryColor = Color(0xFF181818);

  //Text Colors
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color darkTextColor = Color(0xFF0A090A);

  //Other Colors
  static const Color disabledColor = Color(0xFF3A3A3A);
  static const Color red = Color(0xFFFF1F1F);
  static const Color green = Color(0xFF1FFF1F);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color transparent = Colors.transparent;
  static const Color blackPiece = Color(0xFFFFD700);

  static const int _customColorValue = 0xFF9542FF;

  static const MaterialColor primaryColor = MaterialColor(
    _customColorValue,
    <int, Color>{
      50: Color(0xFFF3E6FF),
      100: Color(0xFFDCB3FF),
      200: Color(0xFFC27DFF),
      300: Color(0xFFAA46FF),
      400: Color(0xFF9E23FF),
      500: Color(_customColorValue),
      600: Color(0xFF8E00FF),
      700: Color(0xFF8200FF),
      800: Color(0xFF7500FF),
      900: Color(0xFF6800FF),
    },
  );
}
