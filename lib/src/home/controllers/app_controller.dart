import 'dart:async';
import 'dart:math';

import 'package:extreme_chess_v2/src/global/model/user.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:get/get.dart';
import 'package:stockfish/stockfish.dart';

import '../../plugin/chess_board/flutter_chess_board.dart';

class AppController extends GetxController {
  Rx<HomeActions> currentHomeAction = HomeActions.home.obs;
  Rx<ChessEngines> selectedChessEngine = ChessEngines.easy.obs;
  Rx<ChessEngineState> currentChessState = ChessEngineState.initial.obs;
  var stockfish = Stockfish();
  late ChessBoardController chessController;
  RxInt bTime = 0.obs;
  RxInt wTime = 0.obs;
  // RxBool isGameOver = false.obs;
  RxBool isTimeout = false.obs;
  Rx<Color> userColor = Chess.WHITE.obs;
  Rx<User> currentOpponent =
      User(firstName: ChessEngines.easy.title, image: ChessEngines.easy.icon)
          .obs;
  Rx<User> currentUser =
      User(firstName: "Extreme", lastName: "Player", image: "").obs;

  RxString get wTimeString => _formatDuration(wTime.value).obs;
  RxString get bTimeString => _formatDuration(bTime.value).obs;
  Rx<ChessGameState> cgs = ChessGameState.loser.obs;
  Timer? _timer;

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

  setTimeForPlayers(ChessBoardController chessControllerv) {
    isTimeout.value = false;
    chessController = chessControllerv;

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
    setTimeForPlayers(chessController);
  }

  cancelTime() {
    _timer?.cancel();
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
}
