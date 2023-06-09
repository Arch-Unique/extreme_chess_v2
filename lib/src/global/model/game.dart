import 'barrel.dart';

class Game {
  User black, white;
  String pgn, wdl, id;

  Game(
      {required this.black,
      required this.white,
      this.pgn = "",
      this.wdl = "",
      this.id = ""});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
        black: User.fromColorJson(json, "black"),
        white: User.fromColorJson(json, "white"),
        pgn: json["pgn"] ?? "",
        id: json["id"],
        wdl: json["wdl"]);
  }
}
