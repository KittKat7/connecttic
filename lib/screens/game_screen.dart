import 'package:connecttic/models/game_manager.dart';
import 'package:connecttic/widgets/gameednpopup_widget.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../widgets/gameboard_widget.dart';

const double _textScale = 2;

/// This screen displays the game board and is how the player interacts with the game.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onGameEnd() {
    showDialog(
        context: context,
        builder: (BuildContext context) => const GameEndPopup(
              winnerUsername: "TODO",
              time: "TODO",
            ));
  }

  @override
  Widget build(BuildContext context) {
    /// The widget display for the player usernames.
    Widget player0Name = Text(
      getLang('pmtPlayer', [0 + 1]),
      textScaler: const TextScaler.linear(_textScale),
    );
    Widget player1Name = Text(
      getLang('pmtPlayer', [1 + 1]),
      textScaler: const TextScaler.linear(_textScale),
    );

    /// The widget which displays the current game board.
    var gameBoard = GameBoard(
        gameManager: GameManager.getGM(),
        changeCallback: () => setState(() {}));

    /// The lower row which is displayed below the board.
    var row = Row(
      children: [
        Expanded(flex: 2, child: player0Name),
        // Expanded(flex: 1, child: player1Tile),
        const Expanded(flex: 0, child: SizedBox()),
        // Expanded(flex: 1, child: player2Tile),
        Expanded(flex: 2, child: player1Name),
      ],
    );

    // Return the scaffold for the screen.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(getLang('titleApp')),
      ),
      // Aspect controls the aspect ratio.
      body: Aspect(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [gameBoard, row],
          ),
        ),
      ),
    );
  }
}
