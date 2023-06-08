import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

import 'src/global/services/dependencies.dart';
import 'src/global/views/pages.dart';
import 'src/src_barrel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await AppDependency.init();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // if (kReleaseMode) exit(1);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    log('PlatformDispatcher.onError: $error');
    log(error.toString(), stackTrace: stack);
    return true;
  };
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, widget) {
        Widget error = const Text('...there was an error...');
        if (widget is Scaffold || widget is Navigator) {
          error = Scaffold(
            body: Center(child: error),
          );
        }

        ErrorWidget.builder = (errorDetails) => error;
        if (widget != null) {
          return widget;
        }
        throw FlutterError('...widget is null...');
      },
      initialRoute: AppRoutes.home,
      title: 'Extreme Chess',
      getPages: AppPages.getPages,
      theme: ThemeData(
          scaffoldBackgroundColor: AppColors.primaryColorBackground,
          fontFamily: Assets.appFontFamily,
          primarySwatch: AppColors.primaryColor),
    );
  }
}