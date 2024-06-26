import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:extreme_chess_v2/src/utils/constants/prefs/prefs.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

enum PasswordStrength {
  normal,
  weak,
  okay,
  strong,
}

enum FPL {
  email(TextInputType.emailAddress),
  number(TextInputType.number),
  text(TextInputType.text),
  password(TextInputType.visiblePassword),
  multi(TextInputType.multiline, maxLength: 1000, maxLines: 5),
  phone(TextInputType.phone),
  money(TextInputType.number),

  //card details
  cvv(TextInputType.number, maxLength: 4),
  cardNo(TextInputType.number, maxLength: 20),
  dateExpiry(TextInputType.datetime, maxLength: 5);

  final TextInputType textType;
  final int? maxLength, maxLines;

  const FPL(this.textType, {this.maxLength, this.maxLines = 1});
}

enum AuthMode {
  login("Log In", "Login with one following options", "Don't have an account? ",
      "Register here!", "Or Log in with"),
  register("Sign Up", "You can sign up with one following options",
      "Already have an account? ", "Login!", "Or sign up with");

  final String title, desc, after, afterAction, thirdparty;
  const AuthMode(
      this.title, this.desc, this.after, this.afterAction, this.thirdparty);
}

enum ThirdPartyTypes {
  facebook(Brands.facebook_f),
  google(Brands.google),
  apple(Brands.apple_logo);

  final String logo;
  const ThirdPartyTypes(this.logo);
}

enum ErrorTypes {
  noInternet(Icons.wifi_tethering_off_rounded, "No Internet Connection",
      "Please check your internet connection and try again"),
  serverFailure(Icons.power_off_rounded, "Server Failure",
      "Something bad happened. Please try again later");

  final String title, desc;
  final dynamic icon;
  const ErrorTypes(this.icon, this.title, this.desc);
}

enum HomeActions {
  engine("Conquer AI Engines", "Challenge the worldclass Stockfish Engine",
      Assets.robot, "Challenge"),
  home("Challenge Opponents Worldwide",
      "Play with random people all over the world", Assets.console, "Play"),

  leaderboard("Witness Extreme Chess Legends",
      "View the leaderboard to know where you rank", Assets.podium, "View");

  final String title, desc, image, btn;
  const HomeActions(this.title, this.desc, this.image, this.btn);
}

enum ChessEngines {
  easy(
      "Chaos",
      Assets.easy,
      Color(0xffffd5b4),
      2750,
      300000,
      "In the realm where silence weeps and battles brew,\nChaos emerges swift and true.\nWithin five minutes, it paints a tapestry of strife,\nUnleashing mayhem, embodying the essence of life.",
      MyPrefs.mpUsercWDL),
  medium(
      "Mayhem",
      Assets.medium,
      Color(0xffffe5e5),
      2900,
      180000,
      "Rising from the depths, a tempest takes its form,\nMayhem, heralds a ferocious storm.\nIn three minutes' time, it dances on the edge,\nA master of chaos, leaving opponents on a ledge.",
      MyPrefs.mpUsermWDL),
  hard(
      "Brutal",
      Assets.hard,
      Colors.white,
      3150,
      60000,
      "Behold the epitome of ruthless might,\nBrutal, a warrior cloaked in night.\nIn just one minute, it strikes with a venomous stare,\nA merciless executioner, leaving no room for repair ",
      MyPrefs.mpUserbWDL);

  final String title, icon, desc, wdls;
  final Color color;
  final int elo, time;
  const ChessEngines(this.title, this.icon, this.color, this.elo, this.time,
      this.desc, this.wdls);
}

enum ChessEngineState { initial, uci, setoptions, newgame, ingame }

enum ChessGameState {
  winner(14, Assets.winner),
  loser(29, Assets.loser),
  draw(3, Assets.draw);

  final int count;
  final String icon;

  const ChessGameState(
    this.count,
    this.icon,
  );
}
