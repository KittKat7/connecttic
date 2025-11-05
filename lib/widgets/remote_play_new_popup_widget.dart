import 'package:connecttic/models/player.dart';
import 'package:connecttic/models/game_manager.dart';
import 'package:connecttic/screens/game_screen.dart';
import 'package:connecttic/widgets/select_player_level.dart';
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
              Text(getLang('pmtPlayer', [0 + 1])),
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
    Navigator.pop(context);
    GameManager.gm = GameManager(
      GameType.remote,
      player1: p1,
      player2: p2,
    );
    GameManager.createRemoteGame(
      () => Navigator.push(context, genRoute(const GameScreen())),
      () => Navigator.pop(context),
    );
  }

  /// _validateUsername validates a provided username [iusername] and returns the validated
  /// username. This validation includes validating/censoring/cleaning and ensuring the username
  /// does not extend past the max length.
  /// TODO
  // ignore: unused_element
  String _validateUsername(String iusername) {
    const int maxUsernameLength = 11;
    return iusername.length > maxUsernameLength
        ? iusername.substring(0, maxUsernameLength)
        : iusername;
  }
}
