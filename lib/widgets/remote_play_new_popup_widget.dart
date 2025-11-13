import '/models/player.dart';
import '/models/game_manager.dart';
import '/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

/// This widget is used to set up the players and board for a local play game.
class RemotePlayNewPopup extends StatefulWidget {
  const RemotePlayNewPopup({super.key});

  @override
  State<RemotePlayNewPopup> createState() => _RemotePlayNewPopupState();
}

class _RemotePlayNewPopupState extends State<RemotePlayNewPopup> {
  Player p1 = Player(level: PlayerLevel.player);
  Player p2 = Player(level: PlayerLevel.player);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(getLang('titleSetupGame')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(getLang('pmtNewRemoteGame')),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(getLang('btnCancel'))),
        TextButton(
            onPressed: () {
              _onConfirmBtnPress(context);
            },
            child: Text(getLang('btnConfirm'))),
      ],
    );
  }

  /// [_onConfirmBtnPress] runs when the confirm btn is pressed. This method pops the popup off the
  /// stack and pushed the [GameScreen] onto the stack.
  void _onConfirmBtnPress(BuildContext context) {
    GameManager.gm = GameManager(
      GameType.remote,
      player1: p1,
      player2: p2,
    );
    GameManager.createRemoteGame(
      () {
        Navigator.pop(context);
        Navigator.push(context, genRoute(const GameScreen()));
      },
      () => Navigator.pop(context),
    );
  }
}
