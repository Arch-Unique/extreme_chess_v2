import 'package:extreme_chess_v2/src/features/home/repos/app_repo.dart';
import 'package:extreme_chess_v2/src/global/controller/connection_controller.dart';
import 'package:extreme_chess_v2/src/global/services/barrel.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:get/get.dart';

class AppDependency {
  static init() async {
    Get.put(MyPrefService());
    Get.put(DioApiService());
    await Get.putAsync(() async {
      final connectTivity = ConnectionController();
      await connectTivity.init();
      return connectTivity;
    });
    await Get.putAsync(() async {
      final appService = AppService();
      await appService.initUserConfig();
      return appService;
    });

    //repos
    Get.put(AppRepo());
    // Get.put(DashboardRepo());
    // Get.put(ProfileRepo());
    // Get.put(FacilityRepo());

    // //controllers
    // Get.put(AuthController());
    Get.put(AppController());
    // Get.put(FacilityController());
  }
}
