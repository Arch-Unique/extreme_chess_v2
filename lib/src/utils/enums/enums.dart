import 'package:extreme_chess_v2/src/src_barrel.dart';
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
  facebook(Logos.facebook_f),
  google(Logos.google),
  apple(Logos.apple);

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
  engine("Conquer AI Engines", "Play with the worldclass Stockfish Engine",
      Assets.robot, "Challenge"),
  home("Challenge Opponents Worldwide",
      "Play with random people all over the world", Assets.console, "Play"),

  leaderboard("Witness Extreme Chess Legends",
      "View the leaderboard to know where you rank", Assets.podium, "View");

  final String title, desc, image, btn;
  const HomeActions(this.title, this.desc, this.image, this.btn);
}

enum ChessEngines {
  easy("Chaos", Assets.easy, 2750, 300000),
  medium("Mayhem", Assets.medium, 2900, 180000),
  hard("Brutal", Assets.hard, 3150, 60000);

  final String title, icon;
  final int elo, time;
  const ChessEngines(this.title, this.icon, this.elo, this.time);
}

enum ChessEngineState { initial, uci, setoptions, newgame, ingame }
