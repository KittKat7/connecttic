import 'package:connecttic/models/game_object.dart';
import 'package:connecttic/widgets/gameednpopup_widget.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../widgets/gameboard_widget.dart';

const double _textScale = 2;

/// This screen displays the game board and is how the player interacts with the game.
class GameScreen extends StatefulWidget {
  final Game game;
  const GameScreen({super.key, required this.game});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    // When initing state, set the onCallBack function in the game to launch the end game popup.
    widget.game.setOnEndCallback(onGameEnd);
  }

  void onGameEnd() {
    Map<String, String> gameInfo = widget.game.getGameInfo();
    showDialog(
        context: context,
        builder: (BuildContext context) => GameEndPopup(
              winnerUsername: gameInfo["winner"]!,
              time: gameInfo["time"]!,
            ));
  }

  @override
  Widget build(BuildContext context) {
    BlockerObject.setColor(colorScheme(context).primary);

    /// Player 0 and 1 in the game.
    Player player0 = widget.game.players[0];
    Player player1 = widget.game.players[1];

    /// The widget display for the player usernames.
    Widget player0Name = Text(
      player0.username,
      textScaler: const TextScaler.linear(_textScale),
    );
    Widget player1Name = Text(
      player1.username,
      textScaler: const TextScaler.linear(_textScale),
    );

    /// Tiles/widgets for the players.
    Widget player0Tile = player0.getTile();
    Widget player1Tile = player1.getTile();
    // If the player is the current player, use the big tile.
    if (widget.game.getCurrentPlayer() == widget.game.players[0]) {
      player0Tile = widget.game.players[0].getBigTile();
    } else {
      player1Tile = widget.game.players[1].getBigTile();
    }

    /// Listens to the time on the game timer. When the time updates, return a new Text widget which
    /// displays the updated time.
    var valueListenableBuilder = ValueListenableBuilder<int>(
        valueListenable: widget.game.timeNotifier,
        builder: (context, seconds, child) {
          return Text(
            getLang('mscMinSec', [
              (seconds ~/ 60).toString().padLeft(2, '0'),
              (seconds % 60).toString().padLeft(2, '0')
            ]),
            textScaler: const TextScaler.linear(_textScale),
          );
        });

    /// The widget which displays the current game board.
    var gameBoard = GameBoard(
        board: widget.game.board,
        tapCallBack: (a, b) => setState(() => widget.game.play(a, b)));

    /// The lower row which is displayed below the board.
    var row = Row(
      children: [
        Expanded(flex: 2, child: player0Name),
        Expanded(flex: 1, child: player0Tile),
        const Expanded(flex: 0, child: SizedBox()),
        Expanded(flex: 1, child: player1Tile),
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
            children: [valueListenableBuilder, gameBoard, row],
          ),
        ),
      ),
    );
  }
}
/*

      ? Transform.scale(scale: 1, child: _marker)
      : Transform.scale(scale: 0.75, child: _marker);
      */