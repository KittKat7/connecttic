import 'package:connecttic/models/game_manager.dart';
import 'package:connecttic/widgets/gameednpopup_widget.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../models/audio_player.dart';
import '../models/game.dart';
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

  @override
  void setState(Function() f) {
    super.setState(f);
    GameStatus status = GameManager.getGM().status;
    if (status != GameStatus.playing && status != GameStatus.idle) {
      String winner = '';
      if (status == GameStatus.player1) winner = getLang('pmtPlayer', [1]);
      if (status == GameStatus.player2) winner = getLang('pmtPlayer', [2]);
      if (status == GameStatus.draw) winner = getLang('pmtDraw');
      onGameEnd(winner);
    }
  }

  void onGameEnd(String winner) {
    showDialog(
        context: context,
        builder: (BuildContext context) => GameEndPopup(
              winnerUsername: winner,
              time: "TODO",
            ));
  }

  @override
  Widget build(BuildContext context) {
    /// The widget display for the player usernames.
    Widget player1Name = Text(
      getLang('pmtPlayer', [1]),
      textScaler: const TextScaler.linear(_textScale),
    );
    Widget player2Name = Text(
      getLang('pmtPlayer', [2]),
      textScaler: const TextScaler.linear(_textScale),
    );

    /// The widget which displays the current game board.
    var gameBoard = GameBoard(
        gameManager: GameManager.getGM());

    GameManager.getGM().updateCallback = () {
      AppAudio.getInstance().playEffect(AppAudio.effectPop);
      setState((){});
    };

    /// The lower row which is displayed below the board.
    var row = Row(
      children: [
        Expanded(flex: 2, child: player1Name),
        Expanded(
            flex: 1,
            child: GameManager.getGM().currentPlayer == Game.p1
                ? GameBoard.Player1TileSup
                : GameBoard.Player1Tile),
        const Expanded(flex: 0, child: SizedBox()),
        Expanded(
            flex: 1,
            child: GameManager.getGM().currentPlayer == Game.p2
                ? GameBoard.Player2TileSup
                : GameBoard.Player2Tile),
        Expanded(flex: 2, child: player2Name),
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
