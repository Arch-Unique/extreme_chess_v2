import 'dart:math';

import 'package:chess_vectors_flutter/chess_vectors_flutter.dart';
import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:get/get.dart';
import '../../../utils/utils_barrel.dart';
import 'board_arrow.dart';
import 'chess_board_controller.dart';
import 'constants.dart';

class ChessBoard extends StatefulWidget {
  /// An instance of [ChessBoardController] which holds the game and allows
  /// manipulating the board programmatically.
  final ChessBoardController controller;

  /// Size of chessboard
  final double? size;

  /// A boolean which checks if the user should be allowed to make moves
  final bool enableUserMoves;

  final PlayerColor boardOrientation;

  final VoidCallback? onMove;

  final List<BoardArrow> arrows;

  const ChessBoard({
    Key? key,
    required this.controller,
    this.size,
    this.enableUserMoves = true,
    this.boardOrientation = PlayerColor.white,
    this.onMove,
    this.arrows = const [],
  }) : super(key: key);

  @override
  State<ChessBoard> createState() => _ChessBoardState();
}

class _ChessBoardState extends State<ChessBoard> {
  static final lightSquare = Color(0xFFF3F3F3);
  static final darkSquare = Color(0xFF3A3A3A);
  final controller = Get.find<AppController>();

  @override
  void initState() {
    // TODO: implement initState
    controller.isTimeout.listen((p0) {
      if (p0) {
        _showGameOver(widget.controller.game);
      }
    });
    widget.controller.addListener(() {
      if (widget.controller.game.game_over) {
        _showGameOver(widget.controller.game);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final w = Ui.width(context) / 8;
    return ValueListenableBuilder<chess.Chess>(
      valueListenable: widget.controller,
      builder: (context, game, _) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            children: [
              // AspectRatio(
              //   child: _getBoardImage(),
              //   aspectRatio: 1.0,
              // ),
              AspectRatio(
                aspectRatio: 1.0,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8),
                  itemBuilder: (context, index) {
                    var row = index ~/ 8;
                    var column = index % 8;
                    var boardRank = widget.boardOrientation == PlayerColor.black
                        ? '${row + 1}'
                        : '${(7 - row) + 1}';
                    var boardFile = widget.boardOrientation == PlayerColor.white
                        ? '${files[column]}'
                        : '${files[7 - column]}';

                    var squareName = '$boardFile$boardRank';
                    var pieceOnSquare = game.get(squareName);

                    var piece = BoardPiece(
                      squareName: squareName,
                      game: game,
                    );

                    PieceMoveData? moveData = PieceMoveData(
                      squareName: squareName,
                      pieceType: pieceOnSquare?.type.toUpperCase() ?? 'P',
                      pieceColor: pieceOnSquare?.color ?? chess.Color.WHITE,
                    );

                    var draggable = game.get(squareName) != null
                        ? Draggable<PieceMoveData>(
                            child: piece,
                            feedback: game.get(squareName)?.color ==
                                    controller.userColor.value
                                ? piece
                                : SizedBox(),
                            childWhenDragging: SizedBox(),
                            data: moveData,
                            onDragStarted: () {
                              // Clear moveData when dragging starts
                              moveData = null;
                            },
                          )
                        : Container();

                    var dragTarget =
                        DragTarget<PieceMoveData>(builder: (context, list, _) {
                      return draggable;
                    }, onWillAccept: (pieceMoveData) {
                      return controller.userColor.value == game.turn;
                    }, onAccept: (PieceMoveData pieceMoveData) async {
                      // A way to check if move occurred.
                      chess.Color moveColor = game.turn;

                      if (pieceMoveData.pieceType == "P" &&
                          ((pieceMoveData.squareName[1] == "7" &&
                                  squareName[1] == "8" &&
                                  pieceMoveData.pieceColor ==
                                      chess.Color.WHITE) ||
                              (pieceMoveData.squareName[1] == "2" &&
                                  squareName[1] == "1" &&
                                  pieceMoveData.pieceColor ==
                                      chess.Color.BLACK))) {
                        var val = await _promotionDialog(context);

                        if (val != null) {
                          final rs = widget.controller.makeMoveWithPromotion(
                            from: pieceMoveData.squareName,
                            to: squareName,
                            pieceToPromoteTo: val,
                          );
                          if (!controller.isOfflineMode.value && rs) {
                            controller.moveOnlineGame(
                                "${pieceMoveData.squareName}$squareName$val");
                          }
                        } else {
                          return;
                        }
                      } else {
                        final rs = widget.controller.makeMove(
                          from: pieceMoveData.squareName,
                          to: squareName,
                        );
                        if (!controller.isOfflineMode.value && rs) {
                          controller.moveOnlineGame(
                              "${pieceMoveData.squareName}$squareName");
                        }
                      }
                      if (game.turn != moveColor) {
                        widget.onMove?.call();
                      }
                    });

                    return GestureDetector(
                      onTap: () {
                        if (moveData == null) {
                          if (pieceOnSquare != null &&
                              pieceOnSquare.color == game.turn) {
                            moveData = PieceMoveData(
                              squareName: squareName,
                              pieceType: pieceOnSquare.type.toUpperCase(),
                              pieceColor: pieceOnSquare.color,
                            );
                          }
                        } else {
                          // Second tap on the same piece, clear moveData
                          moveData = null;
                        }
                      },
                      child: Container(
                        width: w,
                        height: w,
                        child: dragTarget,
                        color: _getSquareColor(row, column),
                      ),
                    );
                  },
                  itemCount: 64,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                ),
              ),
              if (widget.arrows.isNotEmpty)
                IgnorePointer(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: CustomPaint(
                      child: Container(),
                      painter:
                          _ArrowPainter(widget.arrows, widget.boardOrientation),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// Returns the board image
  Image _getBoardImage() {
    return Image.asset(
      Assets.chessboard,
      fit: BoxFit.cover,
    );
  }

  Color _getSquareColor(int r, int c) {
    return r.isOdd
        ? (c.isOdd ? lightSquare : darkSquare)
        : (c.isOdd ? darkSquare : lightSquare);
  }

  /// Show dialog when pawn reaches last square
  Future<String?> _promotionDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose promotion'),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                child: WhiteQueen(),
                onTap: () {
                  Navigator.of(context).pop("q");
                },
              ),
              InkWell(
                child: WhiteRook(),
                onTap: () {
                  Navigator.of(context).pop("r");
                },
              ),
              InkWell(
                child: WhiteBishop(),
                onTap: () {
                  Navigator.of(context).pop("b");
                },
              ),
              InkWell(
                child: WhiteKnight(),
                onTap: () {
                  Navigator.of(context).pop("n");
                },
              ),
            ],
          ),
        );
      },
    ).then((value) {
      return value;
    });
  }

  Future _showGameOver(chess.Chess game) async {
    controller.cancelTime();
    bool winnerIsUser = game.turn != controller.userColor.value;
    final user = winnerIsUser
        ? controller.appRepo.appService.currentUser.value
        : controller.currentOpponent.value;
    String msg = "";
    String title = "";

    String getMsg(bool wiu) {
      if (wiu) {
        controller.cgs.value = ChessGameState.winner;
        return "Congrats , You won";
      } else {
        controller.cgs.value = ChessGameState.loser;
        return "${user.username} won, Try again next time ";
      }
    }

    if (game.in_checkmate) {
      title = "CHECKMATE";
      msg = getMsg(winnerIsUser);
    } else if (game.in_draw) {
      controller.cgs.value = ChessGameState.draw;
      if (game.in_stalemate) {
        title = "STALEMATE";
      } else if (game.in_threefold_repetition) {
        title = "3 FOLD REPITITION";
      } else if (game.insufficient_material) {
        title = "INSUFFICIENT MATERIAL";
      }
      msg = "You draw, Nice one";
    } else if (controller.isTimeout.value) {
      title = "TIME OUT";
      if (controller.wTime.value > controller.bTime.value) {
        winnerIsUser = controller.userColor.value == chess.Color.WHITE;
        msg = getMsg(winnerIsUser);
      } else {
        winnerIsUser = controller.userColor.value == chess.Color.BLACK;
        msg = getMsg(winnerIsUser);
      }
    }

    if (controller.isOfflineMode.value) {
      await controller.appRepo.appService.setUserWDL(
          controller.selectedChessEngine.value.wdls, controller.cgs.value);
    } else {}

    final meme = controller.getRandomMeme();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AlertDialog(
                title: AppText.bold(title,
                    fontSize: 24,
                    color: AppColors.darkTextColor,
                    alignment: TextAlign.center),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppText.medium(msg, color: AppColors.darkTextColor),
                    Ui.boxHeight(8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Ui.showInfo(
                                  "Support for downloading of pgn coming soon");
                            },
                            icon: Icon(
                              Icons.download_rounded,
                              color: AppColors.darkTextColor,
                            )),
                        Ui.boxWidth(12),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              widget.controller.resetBoard();
                              if (controller.isOfflineMode.value) {
                                controller.setTimeForPlayers();
                              } else {
                                Ui.showInfo(
                                    "Support for restarting games coming soon");
                              }
                            },
                            icon: Icon(
                              Icons.restart_alt_rounded,
                              color: AppColors.darkTextColor,
                            )),
                        Ui.boxWidth(12),
                        IconButton(
                            onPressed: () {
                              try {
                                Navigator.of(context).pop();
                                Get.offAllNamed(AppRoutes.home);
                              } catch (e) {
                                print(e);
                              }
                            },
                            icon: Icon(
                              Icons.home_outlined,
                              color: AppColors.darkTextColor,
                            ))
                      ],
                    ),
                    Ui.boxHeight(12),
                    Image.asset(
                      meme,
                      width: Ui.width(context),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class BoardPiece extends StatelessWidget {
  final String squareName;
  final chess.Chess game;

  const BoardPiece({
    Key? key,
    required this.squareName,
    required this.game,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Widget imageToDisplay;
    var square = game.get(squareName);

    if (game.get(squareName) == null) {
      return Container();
    }

    String piece = (square?.color == chess.Color.WHITE ? 'W' : 'B') +
        (square?.type.toUpperCase() ?? 'P');

    switch (piece) {
      case "WP":
        imageToDisplay = WhitePawn();
        break;
      case "WR":
        imageToDisplay = WhiteRook();
        break;
      case "WN":
        imageToDisplay = WhiteKnight();
        break;
      case "WB":
        imageToDisplay = WhiteBishop();
        break;
      case "WQ":
        imageToDisplay = WhiteQueen();
        break;
      case "WK":
        imageToDisplay = WhiteKing();
        break;
      case "BP":
        imageToDisplay = BlackPawn(
          fillColor: Color(0xFFFFD700),
        );
        break;
      case "BR":
        imageToDisplay = BlackRook(
          fillColor: Color(0xFFFFD700),
        );
        break;
      case "BN":
        imageToDisplay = BlackKnight(
          fillColor: Color(0xFFFFD700),
        );
        break;
      case "BB":
        imageToDisplay = BlackBishop(
          fillColor: Color(0xFFFFD700),
        );
        break;
      case "BQ":
        imageToDisplay = BlackQueen(
          fillColor: Color(0xFFFFD700),
        );
        break;
      case "BK":
        imageToDisplay = BlackKing(
          fillColor: Color(0xFFFFD700),
        );
        break;
      default:
        imageToDisplay = WhitePawn();
    }

    return imageToDisplay;
  }
}

class PieceMoveData {
  final String squareName;
  final String pieceType;
  final chess.Color pieceColor;

  PieceMoveData({
    required this.squareName,
    required this.pieceType,
    required this.pieceColor,
  });
}

class _ArrowPainter extends CustomPainter {
  List<BoardArrow> arrows;
  PlayerColor boardOrientation;

  _ArrowPainter(this.arrows, this.boardOrientation);

  @override
  void paint(Canvas canvas, Size size) {
    var blockSize = size.width / 8;
    var halfBlockSize = size.width / 16;

    for (var arrow in arrows) {
      var startFile = files.indexOf(arrow.from[0]);
      var startRank = int.parse(arrow.from[1]) - 1;
      var endFile = files.indexOf(arrow.to[0]);
      var endRank = int.parse(arrow.to[1]) - 1;

      int effectiveRowStart = 0;
      int effectiveColumnStart = 0;
      int effectiveRowEnd = 0;
      int effectiveColumnEnd = 0;

      if (boardOrientation == PlayerColor.black) {
        effectiveColumnStart = 7 - startFile;
        effectiveColumnEnd = 7 - endFile;
        effectiveRowStart = startRank;
        effectiveRowEnd = endRank;
      } else {
        effectiveColumnStart = startFile;
        effectiveColumnEnd = endFile;
        effectiveRowStart = 7 - startRank;
        effectiveRowEnd = 7 - endRank;
      }

      var startOffset = Offset(
          ((effectiveColumnStart + 1) * blockSize) - halfBlockSize,
          ((effectiveRowStart + 1) * blockSize) - halfBlockSize);
      var endOffset = Offset(
          ((effectiveColumnEnd + 1) * blockSize) - halfBlockSize,
          ((effectiveRowEnd + 1) * blockSize) - halfBlockSize);

      var yDist = 0.8 * (endOffset.dy - startOffset.dy);
      var xDist = 0.8 * (endOffset.dx - startOffset.dx);

      var paint = Paint()
        ..strokeWidth = halfBlockSize * 0.8
        ..color = arrow.color;

      canvas.drawLine(startOffset,
          Offset(startOffset.dx + xDist, startOffset.dy + yDist), paint);

      var slope =
          (endOffset.dy - startOffset.dy) / (endOffset.dx - startOffset.dx);

      var newLineSlope = -1 / slope;

      var points = _getNewPoints(
          Offset(startOffset.dx + xDist, startOffset.dy + yDist),
          newLineSlope,
          halfBlockSize);
      var newPoint1 = points[0];
      var newPoint2 = points[1];

      var path = Path();

      path.moveTo(endOffset.dx, endOffset.dy);
      path.lineTo(newPoint1.dx, newPoint1.dy);
      path.lineTo(newPoint2.dx, newPoint2.dy);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  List<Offset> _getNewPoints(Offset start, double slope, double length) {
    if (slope == double.infinity || slope == double.negativeInfinity) {
      return [
        Offset(start.dx, start.dy + length),
        Offset(start.dx, start.dy - length)
      ];
    }

    return [
      Offset(start.dx + (length / sqrt(1 + (slope * slope))),
          start.dy + ((length * slope) / sqrt(1 + (slope * slope)))),
      Offset(start.dx - (length / sqrt(1 + (slope * slope))),
          start.dy - ((length * slope) / sqrt(1 + (slope * slope)))),
    ];
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) {
    return arrows != oldDelegate.arrows;
  }
}
