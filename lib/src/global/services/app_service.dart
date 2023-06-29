import 'dart:async';

import 'package:extreme_chess_v2/src/global/model/user.dart';
import 'package:extreme_chess_v2/src/global/services/barrel.dart';
import 'package:extreme_chess_v2/src/plugin/jwt.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:extreme_chess_v2/src/utils/constants/prefs/prefs.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:get/get.dart';

class AppService extends GetxService {
  Rx<User> currentUser = User().obs;
  RxBool hasOpenedOnboarding = false.obs;
  RxBool isLoggedIn = false.obs;
  final apiService = Get.find<DioApiService>();
  final prefService = Get.find<MyPrefService>();

  initUserConfig() async {
    await _hasOpened();
    await _setLoginStatus();
    if (isLoggedIn.value) {
      await _setCurrentUser();
    }
  }

  refreshUser() async {
    if (isLoggedIn.value) {
      await _setCurrentUser();
    }
  }

  loginUser(String jwt) async {
    apiService.socket.auth = {"token": jwt};
    await _saveJWT(jwt);
    await _setCurrentUser();
  }

  logout() async {
    // await apiService.post(AppUrls.logout);
    await _logout();
  }

  setUserWDL(String key, ChessGameState score) async {
    String wdl = prefService.get(key) ?? "0-0-0";
    List<int> wdll = wdl.split("-").map((e) => int.parse(e)).toList();
    switch (score) {
      case ChessGameState.winner:
        wdll[0] = wdll[0] + 1;
        break;
      case ChessGameState.draw:
        wdll[1] = wdll[1] + 1;
        break;
      case ChessGameState.loser:
        wdll[2] = wdll[2] + 1;
        break;
      default:
    }
    final wdls = wdll.join("-");
    await prefService.save(key, wdls);
  }

  List<int> getUserWDL(String key) {
    String wdl = prefService.get(key) ?? "0-0-0";
    List<int> wdll = wdl.split("-").map((e) => int.parse(e)).toList();
    return wdll;
  }

  Map<ChessEngines, List<int>> userEngineStats() {
    Map<ChessEngines, List<int>> map = {};
    for (var element in ChessEngines.values) {
      map[element] = getUserWDL(element.wdls);
    }
    return map;
  }

  _hasOpened() async {
    bool a = prefService.get(MyPrefs.hasOpenedOnboarding) ?? false;
    if (a == false) {
      await prefService.save(MyPrefs.hasOpenedOnboarding, true);
    }
    hasOpenedOnboarding.value = a;
  }

  _logout() async {
    // await prefService.eraseAllExcept(MyPrefs.hasOpenedOnboarding);
    // await GoogleSignIn().disconnect();
    await fb.FirebaseAuth.instance.signOut();
    await prefService.saveAll({
      MyPrefs.mpLoggedInEmail: "",
      MyPrefs.mpLoggedInURLPhoto: "",
      MyPrefs.mpUserElo: 0,
      MyPrefs.mpUserID: "",
      MyPrefs.mpIsLoggedIn: false,
      MyPrefs.mpUserJWT: "",
      MyPrefs.mpLoginExpiry: 0,
      MyPrefs.mpUserName: ""
      // MyPrefs.: currentUser.value.email,
    });
    currentUser.value = User();
    isLoggedIn.value = false;
  }

  _saveJWT(String jwt) async {
    final msg = Jwt.parseJwt(jwt);
    await prefService.saveAll({
      MyPrefs.mpLoginExpiry: msg["exp"],
      MyPrefs.mpUserJWT: jwt,
      MyPrefs.mpIsLoggedIn: true,
    });
  }

  _saveElo(int elo) async {}

  _setCurrentUser() async {
    final res = await apiService.get(AppUrls.getUser);
    print(res.data);
    currentUser.value = User.fromJson(res.data);
    isLoggedIn.value = true;
    await prefService.saveAll({
      MyPrefs.mpLoggedInEmail: currentUser.value.email,
      MyPrefs.mpLoggedInURLPhoto: currentUser.value.image,
      MyPrefs.mpUserElo: currentUser.value.elo,
      MyPrefs.mpUserID: currentUser.value.id,
      MyPrefs.mpUserWins: currentUser.value.wins,
      MyPrefs.mpUserDraws: currentUser.value.draws,
      MyPrefs.mpUserLosses: currentUser.value.losses,
      // MyPrefs.: currentUser.value.email,
    });
  }

  _setLoginStatus() async {
    final e = prefService.get(MyPrefs.mpLoginExpiry) ?? 0;
    if (e != 0 && DateTime.now().millisecondsSinceEpoch > e * 1000) {
      isLoggedIn.value = true;
    }
    isLoggedIn.value = prefService.get(MyPrefs.mpIsLoggedIn) ?? false;
  }
}
