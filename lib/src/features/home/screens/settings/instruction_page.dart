import 'package:extreme_chess_v2/src/global/ui/ui_barrel.dart';
import 'package:extreme_chess_v2/src/global/ui/widgets/others/containers.dart';
import 'package:extreme_chess_v2/src/features/home/controllers/app_controller.dart';
import 'package:extreme_chess_v2/src/src_barrel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
  final controller = Get.find<AppController>();
  @override
  Widget build(BuildContext context) {
    return SinglePageScaffold(
      title: "Instructions",
      child: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                titleItem("Welcome to the Chess Game App! "),
                descItem(
                    "This instruction manual will guide you through the various modes and features of the app, allowing you to fully enjoy the game. Prepare yourself for an extreme hardcore classic chess experience with exciting twists!"),
                titleItem("Part 1: Engine Challenge Mode"),
                descItem('''
In this mode, you can challenge different variants of the Stockfish engine. Each variant has its own unique characteristics:

Chaos:
Time Cap: 5 minutes
Elo Ranking: 2750
Prepare for an unpredictable game where anything can happen within the time limit.

Mayhem:
Time Cap: 3 minutes
Elo Ranking: 2900
Engage in fast-paced battles against Mayhem, testing your skills within a shorter time frame.

Brutal:
Time Cap: 1 minute
Elo Ranking: 3190
Face the ultimate challenge as you compete against Brutal, an engine that demands quick thinking and precision moves.
'''),
                titleItem("Part 2: Online Mode (Grandmaster Arena)"),
                descItem('''
Once you have defeated any of the three engines mentioned above, you will unlock the Online Mode, where you can play against other skilled Grandmasters.

Becoming a Grandmaster:
Defeat one of the three engines (Chaos, Mayhem, or Brutal).
Once accomplished, you will earn the prestigious title of Grandmaster and gain access to the Online Mode.

Online Mode:
Challenge random Grandmasters from around the world.
Engage in thrilling battles of wits and strategy to test your skills against formidable opponents.

Availability of Opponents:
Rest assured that all opponents you encounter in the Online Mode are Grandmasters themselves, having defeated the engines.
If no players are available for online play, you can choose to challenge one of the ten open source chess engines.
'''),
                titleItem("ADDITIONAL FEATURES:"),
                descItem('''
Open Source Chess Engines:
Ten robots, including Stockfish, are available for play in the absence of online opponents.
These engines have no limitations and offer the highest level of chess expertise.

User-Friendly Interface:
Navigate through the app effortlessly with its intuitive and easy-to-use interface.
Enjoy a visually appealing design that enhances your gaming experience.

No Undo Moves:
Just like in real-life chess, there are no undo options available in the game. Each move requires careful consideration and strategy.

Absence of Available Move Highlights:
The game does not display available move highlights when you tap on a chess piece.
This feature encourages players to analyze the board and make their moves based on their own calculations and understanding of the game.

Drag and Drop Movement:
Emulating the physical experience of playing chess, you can only move pieces by dragging and dropping them on the board.
This adds a tactile aspect to the game, enhancing the feeling of playing chess in real life.

No Tutors:
The game does not provide any tutorial or guidance during gameplay.
Players are encouraged to rely on their knowledge and skills to make strategic decisions without external assistance.

Visual Reps for Check:
In contrast to other chess games, there are no visual indicators or highlights to show the safe squares when your king is in check.
This emphasizes the importance of carefully observing the board and finding the best move to escape from check.

Memes for Results:
Upon winning, drawing, or losing a game, the app displays an appropriate meme to add a touch of humor and entertainment.
Enjoy a lighthearted moment as you see a funny meme that reflects the outcome of your game.
'''),
                descItem('''
These features aim to provide a more authentic and challenging chess experience, resembling the nuances of playing chess in real life.
Prepare yourself for intense battles, challenge the engines, become a Grandmaster, and compete with skilled players from around the world. Get ready to immerse yourself in the world of chess like never before!

Enjoy the game and may the best strategist prevail
      '''),
                Ui.boxHeight(24),
              ],
            )),
      ),
    );
  }

  titleItem(String a) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: AppText.bold(a, color: AppColors.black, fontSize: 24),
    );
  }

  descItem(String a) {
    return AppText.thin(a, color: AppColors.darkTextColor, fontSize: 20);
  }
}
