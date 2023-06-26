import 'dart:async';
import 'dart:math';

import 'package:extreme_chess_v2/src/features/home/repos/app_repo.dart';
import 'package:extreme_chess_v2/src/features/home/screens/game_screen.dart';
import 'package:extreme_chess_v2/src/global/model/barrel.dart';
import 'package:extreme_chess_v2/src/global/model/user.dart';
import 'package:extreme_chess_v2/src/global/services/barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockfish/stockfish.dart';

import '../../../plugin/chess_board/flutter_chess_board.dart';

class AppController extends GetxController {
  Rx<HomeActions> currentHomeAction = HomeActions.home.obs;
  Rx<ChessEngines> selectedChessEngine = ChessEngines.easy.obs;
  Rx<ChessEngineState> currentChessState = ChessEngineState.initial.obs;
  RxBool isOfflineMode = true.obs;
  var stockfish = Stockfish();
  late ChessBoardController chessController;
  RxInt bTime = 0.obs;
  RxInt wTime = 0.obs;
  RxInt waitTime = 0.obs;
  // RxBool isGameOver = false.obs;
  RxBool isTimeout = false.obs;
  Rx<Color> userColor = Chess.WHITE.obs;
  Rx<User> currentOpponent =
      User(username: ChessEngines.easy.title, image: ChessEngines.easy.icon)
          .obs;
  final appRepo = Get.find<AppRepo>();
  List<AvailableUser> onlineEngines = [];
  Rx<AvailableUser> selectedOnlineEngine = AvailableUser().obs;
  RxString currentGameID = "".obs;

  RxString get wTimeString => _formatDuration(wTime.value).obs;
  RxString get bTimeString => _formatDuration(bTime.value).obs;
  RxString get waitTimeString => _formatDuration(waitTime.value).obs;
  Rx<ChessGameState> cgs = ChessGameState.loser.obs;
  Timer? _timer, _waitingTimer;

  //ONLINE GAME
  RxBool hasAccepted = false.obs;

  @override
  void onInit() {
    stockfish.state.addListener(() {
      if (stockfish.state.value == StockfishState.ready) {
        stockfish.stdout.listen((event) {
          print(event);
          if (event == "uciok") {
            if (currentChessState.value == ChessEngineState.uci) {
              // stockfish.stdin = "debug off";
              stockfish.stdin = "setoption name Hash value 32";
              stockfish.stdin = "setoption name UCI_LimitStrength value true";
              stockfish.stdin =
                  "setoption name UCI_Elo value ${selectedChessEngine.value.elo}";
              stockfish.stdin = "isready";
              currentChessState.value = ChessEngineState.setoptions;
            }
          } else if (event == "readyok") {
            if (currentChessState.value == ChessEngineState.setoptions) {
              currentChessState.value = ChessEngineState.newgame;
            }
          } else if (event.startsWith("bestmove")) {
            chessController.makeMoveUci(uci: event.split(" ")[1]);
          }
        });
        stockfish.stdin = "uci";
        currentChessState.value = ChessEngineState.uci;
      }
    });

    selectedChessEngine.listen((p0) {
      _changeElo(p0.elo);
    });
    super.onInit();
  }

  reInitStockFish() {
    stockfish = Stockfish();
  }

  _changeElo(int elo) {
    stockfish.stdin = "setoption name UCI_Elo value $elo";
  }

  _startNewGame() {
    currentChessState.value = ChessEngineState.newgame;

    if (currentChessState.value == ChessEngineState.newgame) {
      stockfish.stdin = "ucinewgame";
      currentChessState.value = ChessEngineState.ingame;
    }
  }

  _engineMove() {
    if (currentChessState.value == ChessEngineState.ingame) {
      stockfish.stdin = "position fen ${chessController.getFen()}";
      stockfish.stdin = "go wtime $wTime btime $bTime";
    }
  }

  setChessBoardController(ChessBoardController csv) {
    chessController = csv;
  }

  setTimeForPlayers() {
    isTimeout.value = false;
    // chessController = chessControllerv;

    wTime.value = selectedChessEngine.value.time;
    bTime.value = selectedChessEngine.value.time;
    _startNewGame();

    _startCountdown();
    if (chessController.game.turn != userColor.value) {
      _engineMove();
    }
    chessController.addListener(() {
      if (chessController.game.turn != userColor.value) {
        _engineMove();
      }
    });
  }

  exitGame() {
    cancelTime();
    chessController.resetBoard();
    if (isOfflineMode.value) {
      setTimeForPlayers();
    } else {
      _endOnlineGame();
    }
  }

  cancelTime() {
    _timer?.cancel();
  }

  waitForNewGame({VoidCallback? onEnd, VoidCallback? onSuccess}) {
    waitTime.value = 300000;
    _waitingTimer?.cancel();
    _waitingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      waitTime.value = waitTime.value - 1000;
      if (hasAccepted.value) {
        if (onSuccess != null) {
          timer.cancel();
          onSuccess();
        }
      }
      if (waitTime.value < 1000) {
        timer.cancel();
        if (onEnd != null) {
          onEnd();
        }

        // _startNewGame();
      }
    });
  }

  _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (chessController.game.turn == Chess.WHITE) {
        wTime.value = wTime.value - 1000;
      } else {
        bTime.value = bTime.value - 1000;
      }
      if (wTime.value < 1000 || bTime.value < 1000) {
        print("cancelled");

        if (wTime.value < 1000 || bTime.value < 1000) {
          isTimeout.value = true;
        }
        timer.cancel();

        // _startNewGame();
      }
    });
  }

  String _formatDuration(int durationMs) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final duration = Duration(milliseconds: durationMs);

    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${twoDigits(minutes)}:${twoDigits(seconds)}';
  }

  String getRandomMeme() {
    final l = List.generate(cgs.value.count, (index) => "${index}.webp");
    final ls = Random().nextInt(cgs.value.count);
    return cgs.value.icon + l[ls];
  }

//ONLINE
  setupSocketGame() {
    final socket = appRepo.apiService.socket;

    socket.onAny((event, data) {
      print(event);
      print(data);
    });

    socket.on("invalidAuth", (data) {
      Ui.showError("Invalid Authentication");
      Get.offAll(AppRoutes.home);
    });

    socket.on("invalidGame", (data) {
      Ui.showError("Invalid Game");
      Get.offAll(AppRoutes.home);
    });

    socket.on("timeout", (data) => Ui.showError("Timeout"));

    socket.on("updateFen", (data) {
      chessController.loadFen(data["fen"]);
      wTime.value = data["wtime"];
      bTime.value = data["btime"];
    });

    socket.on("available", (data) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) {
            return AlertDialog(
              backgroundColor: AppColors.black,
              title: AppText.bold("New Game"),
              content: AppText.thin(
                  "You have a new game , are you ready to accept ?"),
              actions: [
                AppButton(
                  onPressed: () async {
                    socket.emit("acceptGame", {
                      "player": appRepo.appService.currentUser.value.id,
                      "id": data,
                    });

                    while (!hasAccepted.value) {}
                    Get.to(GameScreen());
                  },
                  text: "Accept",
                ),
                AppButton(
                  onPressed: () {
                    Get.back();
                  },
                  color: AppColors.red,
                  text: "Decline",
                ),
              ],
            );
          });
    });

    socket.on("accepted", (data) {
      _startOnlineGame(data);
      hasAccepted.value = true;
    });

    socket.on("moveUser", (data) {
      chessController.makeMoveUci(uci: data);
    });

    socket.on("readyToPlay", (data) {
      _startOnlineGame(data);
      hasAccepted.value = true;
    });

    socket.on("availableRobots", (data) {
      onlineEngines = appRepo.apiService.getListOf<AvailableUser>(data);
    });

    socket.on("finished", (data) {});
  }

  //ONLINE ACTIONS
  void createOnlineGame() {
    hasAccepted.value = false;
    appRepo.apiService.socket.emit("createGame", {
      "id": appRepo.appService.currentUser.value.id,
      "isWhite": userColor.value == Color.WHITE
    });
  }

  void getAvailableOnlineEngines() {
    appRepo.apiService.socket.emit("getAvailableEngines");
  }

  void playOnlineEngine() {
    appRepo.apiService.socket.emit("playEngine", {
      "id": appRepo.appService.currentUser.value.id,
      "isWhite": userColor.value == Color.WHITE,
      "engine": selectedOnlineEngine.value.username
    });
  }

  void moveOnlineGame(String uci) {
    appRepo.apiService.socket.emit("move", {
      "game": currentGameID.value,
      "move": uci,
      "winner": wTime.value > bTime.value ? "white" : "black",
      "wtime": wTime.value,
      "btime": bTime.value,
      "engine": selectedOnlineEngine.value.username.isEmpty
          ? null
          : selectedOnlineEngine.value.username,
    });
  }

  void _endOnlineGame() {
    appRepo.apiService.socket.emit("move", {
      "game": currentGameID.value,
      "move": 0,
      "winner": userColor.value == Color.BLACK ? "white" : "black",
      "wtime": wTime.value,
      "btime": bTime.value,
      "engine": selectedOnlineEngine.value.username.isEmpty
          ? null
          : selectedOnlineEngine.value.username,
    });
  }

  void _startOnlineGame(data) {
    final game = Game.fromJson(data);
    currentGameID.value = game.id;
    //setup game
    isTimeout.value = false;
    userColor.value = game.white.id == appRepo.appService.currentUser.value.id
        ? Color.WHITE
        : Color.BLACK;
    currentOpponent.value =
        game.white.id == appRepo.appService.currentUser.value.id
            ? game.black
            : game.white;
    isOfflineMode.value = false;
    wTime.value = 300000;
    bTime.value = 300000;
    _startCountdown();
  }
}
