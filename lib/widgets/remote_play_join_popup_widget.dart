import '/models/player.dart';
import '/models/game_manager.dart';
import '/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

/// This widget is used to set up the players and board for a local play game.
class RemotePlayJoinPopup extends StatefulWidget {
  const RemotePlayJoinPopup({super.key});

  @override
  State<RemotePlayJoinPopup> createState() => _RemotePlayJoinPopupState();
}

class _RemotePlayJoinPopupState extends State<RemotePlayJoinPopup> {
  Player p1 = Player(level: PlayerLevel.player);
  Player p2 = Player(level: PlayerLevel.player);

  @override
  Widget build(BuildContext context) {
    String hash = "";
    return AlertDialog(
      title: Text(getLang('titleSetupGame')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => hash = value,
                  decoration: InputDecoration(hintText: getLang('pmtGameCode')),
                ),
              ),
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
              _onConfirmBtnPress(context, hash);
            },
            child: Text(getLang('btnConfirm'))),
      ],
    );
  }

  /// [_onConfirmBtnPress] runs when the confirm btn is pressed. This method pops the popup off the
  /// stack and pushed the [GameScreen] onto the stack.
  void _onConfirmBtnPress(BuildContext context, String hash) {
    GameManager.gm = GameManager(
      GameType.local,
      player1: p1,
      player2: p2,
    );
    GameManager.joinRemoteGame(
      hash,
      () {
        Navigator.pop(context);
        Navigator.push(context, genRoute(const GameScreen()));
      },
      () {},
    );
  }
}
