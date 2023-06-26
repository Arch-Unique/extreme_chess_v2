import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/features/home/screens/dashboard_screen.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:extreme_chess_v2/src/utils/constants/routes/middleware/auth_middleware.dart';
import 'package:get/get.dart';

class AppPages {
  static List<GetPage> getPages = [
    GetPage(
      name: AppRoutes.home,
      page: () => DashboardScreen(),
      // middlewares: [AuthMiddleWare()]
    ),
    // GetPage(name: AppRoutes.auth, page: () => AuthScreen()),
    // GetPage(name: AppRoutes.dashboard, page: () => DashboardScreen()),
  ];
}
