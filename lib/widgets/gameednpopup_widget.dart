import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

/// This widget is used to set up the players and board for a local play game.
class GameEndPopup extends StatelessWidget {
  final String winnerUsername;
  const GameEndPopup({super.key, required this.winnerUsername});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(getLang('titleGameOver')),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(getLang('pmtWinner', [winnerUsername])),
      ]),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(getLang('btnConfirm'))),
      ],
    );
  }
}
