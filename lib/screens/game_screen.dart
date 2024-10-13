import 'package:connecttic/widgets/gameboard_widget.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../models/game.dart';

/// This screen displays the game board and is how the player interacts with the game.
class GameScreen extends StatefulWidget {
  final Game game;

  const GameScreen({super.key, required this.game});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    widget.game.players[0].tile.highlight =
        widget.game.getCurrentPlayer() == widget.game.players[0];
    widget.game.players[1].tile.highlight =
        widget.game.getCurrentPlayer() == widget.game.players[1];
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
            children: [
              Text("TODO TIME"),
              GameBoard(
                  board: widget.game.board,
                  tapCallBack: (a, b) =>
                      setState(() => widget.game.play(a, b))),
              Row(
                children: [
                  Expanded(child: Text(widget.game.players[0].username)),
                  Expanded(child: widget.game.players[0].tile.marker),
                  Expanded(child: SizedBox()),
                  Expanded(child: widget.game.players[1].tile.marker),
                  Expanded(child: Text(widget.game.players[1].username)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
