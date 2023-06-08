import 'dart:async';

import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:get/get.dart';
import 'package:stockfish/stockfish.dart';

import '../../plugin/chess_board/flutter_chess_board.dart';

class DashboardController extends GetxController {
  Rx<HomeActions> currentHomeAction = HomeActions.home.obs;
  Rx<ChessEngines> selectedChessEngine = ChessEngines.easy.obs;
  Rx<ChessEngineState> currentChessState = ChessEngineState.initial.obs;
  final stockfish = Stockfish();
  late ChessBoardController chessController;
  RxInt bTime = 0.obs;
  RxInt wTime = 0.obs;
  Rx<Color> userColor = Chess.WHITE.obs;

  RxString get wTimeString => _formatDuration(wTime.value).obs;
  RxString get bTimeString => _formatDuration(bTime.value).obs;

  @override
  void onInit() {
    stockfish.state.addListener(() {
      if (stockfish.state.value == StockfishState.ready) {
        stockfish.stdout.listen((event) {
          if (event == "uciok") {
            if (currentChessState.value == ChessEngineState.uci) {
              stockfish.stdin = "debug off";
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

  _changeElo(int elo) {
    stockfish.stdin = "setoption name UCI_Elo value $elo";
  }

  _startNewGame() {
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
    chessController = chessControllerv;

    wTime.value = selectedChessEngine.value.time;
    bTime.value = selectedChessEngine.value.time;
    _startNewGame();

    _startCountdown();
    chessController.addListener(() {
      if (chessController.game.turn != userColor.value) {
        _engineMove();
      }
    });
  }

  _startCountdown() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (wTime.value == 0 || bTime.value == 0) {
        timer.cancel();
      }
      if (chessController.game.turn == Chess.WHITE) {
        wTime.value = wTime.value - 1000;
      } else {
        bTime.value = bTime.value - 1000;
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
}
