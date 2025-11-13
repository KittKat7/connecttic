import '/models/player.dart';
import '/models/game_manager.dart';
import '/screens/game_screen.dart';
import '/widgets/select_player_level.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

/// This widget is used to set up the players and board for a local play game.
class LocalPlayPopup extends StatefulWidget {
  const LocalPlayPopup({super.key});

  @override
  State<LocalPlayPopup> createState() => _LocalPlayPopupState();
}

class _LocalPlayPopupState extends State<LocalPlayPopup> {
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
          SelectPlayerLevel(player: p1),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(getLang('pmtPlayer', [1 + 1])),
            ],
          ),
          SelectPlayerLevel(player: p2),
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
      GameType.local,
      player1: p1,
      player2: p2,
    );
    Navigator.push(context, genRoute(const GameScreen()));
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
