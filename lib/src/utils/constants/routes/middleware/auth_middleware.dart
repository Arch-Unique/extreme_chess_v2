import 'package:extreme_chess_v2/src/global/services/barrel.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';

import '../route.dart';

class AuthMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final controller = Get.find<AppService>();
    if (controller.hasOpenedOnboarding.value) {
      if (controller.isLoggedIn.value) {
        return const RouteSettings(name: AppRoutes.dashboard);
      } else {
        return const RouteSettings(name: AppRoutes.auth);
      }
    }
    return super.redirect(route);
  }
}
