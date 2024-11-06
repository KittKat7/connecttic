import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

/// A popup that is displayed at the end of the game, announcing the winner
class GameEndPopup extends StatelessWidget {
  /// String with the username of the winning player.
  final String winnerUsername;

  /// Const constructor.
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
              // Pop twice dismis popup and dismis game screen, going back to mode screen.
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(getLang('btnConfirm'))),
      ],
    );
  }
}
