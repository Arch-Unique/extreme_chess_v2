import 'package:extreme_chess_v2/src/global/interfaces/pref_service.dart';
// import 'package:extreme_chess_v2/src/global/model/barrel.dart';
import 'package:extreme_chess_v2/src/global/services/barrel.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../global/model/game.dart';
import '../../../global/model/user.dart' as app;

class AppRepo {
  final apiService = Get.find<DioApiService>();
  final appService = Get.find<AppService>();
  final prefService = Get.find<MyPrefService>();

  Future<List<app.User>> getLeaderboard() async {
    final l = await apiService.get(AppUrls.leaderboard, hasToken: false);
    return apiService.getListOf<app.User>(l.data);
  }

  Future<List<Game>> getGameHistory() async {
    final l = await apiService.get(AppUrls.history);
    return apiService.getListOf<Game>(l.data);
  }

  Future<List<app.AvailableUser>> getRobots() async {
    final l = await apiService.get(AppUrls.engine, hasToken: false);
    return apiService.getListOf<app.AvailableUser>(l.data);
  }

  //set elo

  loginSocial(ThirdPartyTypes tpt) async {
    String token = "";
    switch (tpt) {
      case ThirdPartyTypes.apple:
        token = await _loginWithApple();
        break;
      case ThirdPartyTypes.google:
        token = await _loginWithGoogle();
        break;
      case ThirdPartyTypes.facebook:
        token = await _loginWithFacebook();
        break;
      default:
    }

    final res = await apiService.post(AppUrls.login,
        data: {"token": token}, hasToken: false);
    if (res.statusCode!.isSuccess()) {
      await appService.loginUser(res.data["data"]["accessToken"]);
    }
  }

  Future<String> _loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final user = await FirebaseAuth.instance.signInWithCredential(credential);
    final token = await user.user?.getIdToken();
    return token ?? "";
  }

  Future<String> _loginWithApple() async {
    final appleProvider = AppleAuthProvider();
    final user = await FirebaseAuth.instance.signInWithProvider(appleProvider);
    final token = await user.user?.getIdToken();
    return token ?? "";
  }

  Future<String> _loginWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final user = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
    final token = await user.user?.getIdToken();
    return token ?? "";
  }
}
