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
    widget.game.setOnEndCallback(
      (winner) => showDialog(
          context: context,
          builder: (BuildContext context) =>
              GameEndPopup(winnerUsername: winner)),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Player player0 = widget.game.players[0];
    Player player1 = widget.game.players[1];

    Widget player0Name = Text(
      player0.username,
      textScaler: const TextScaler.linear(_textScale),
    );
    Widget player1Name = Text(
      player1.username,
      textScaler: const TextScaler.linear(_textScale),
    );
    Widget player0Tile = player0.getTile();
    Widget player1Tile = player1.getTile();
    if (widget.game.getCurrentPlayer() == widget.game.players[0]) {
      player0Tile = widget.game.players[0].getBigTile();
    } else {
      player1Tile = widget.game.players[1].getBigTile();
    }

    var valueListenableBuilder = ValueListenableBuilder<int>(
        valueListenable: widget.game.timeNotifier,
        builder: (context, seconds, child) {
          return Text(
            '$seconds',
            textScaler: const TextScaler.linear(_textScale),
          );
        });
    var gameBoard = GameBoard(
        board: widget.game.board,
        tapCallBack: (a, b) => setState(() => widget.game.play(a, b)));
    var row = Row(
      children: [
        Expanded(child: player0Name),
        Expanded(child: player0Tile),
        const Expanded(child: SizedBox()),
        Expanded(child: player1Tile),
        Expanded(child: player1Name),
      ],
    );
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