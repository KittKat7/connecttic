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
                  tapCallBack: (a, b) {
                    setState(() => widget.game.play(a, b));
                    widget.game.board.printBoard();
                  }),
              Row(
                children: [
                  Text(widget.game.players[0].username),
                  Expanded(child: SizedBox()),
                  Text(widget.game.players[1].username),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
