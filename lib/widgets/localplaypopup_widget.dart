import 'package:connecttic/models/board.dart';
import 'package:connecttic/models/game.dart';
import 'package:connecttic/models/player.dart';
import 'package:connecttic/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../models/computer_player.dart';

/// This widget is used to set up the players and board for a local play game.
class LocalPlayPopup extends StatefulWidget {
  const LocalPlayPopup({super.key});

  @override
  State<LocalPlayPopup> createState() => _LocalPlayPopupState();
}

class _LocalPlayPopupState extends State<LocalPlayPopup> {
  List<String> username = [getLang('pmtPlayer1'), getLang('pmtPlayer2')];
  List<bool> ai = [false, true];

  @override
  Widget build(BuildContext context) {
    // Widgets for entry fields or checkboxes
    var username0Field = Expanded(
        flex: 4,
        child: TextFormField(
          initialValue: username[0],
          onChanged: (v) => username[0] = _validateUsername(v),
        ));
    var ai0Checkbox = Expanded(
        flex: 1,
        child: Checkbox(
          value: ai[0],
          onChanged: (t) => setState(() => ai[0] = !ai[0]),
        ));
    var username1Field = Expanded(
        flex: 4,
        child: TextFormField(
            initialValue: username[1],
            onChanged: (v) => username[1] = _validateUsername(v)));
    var ai1Checkbox = Expanded(
        flex: 1,
        child: Checkbox(
          value: ai[1],
          onChanged: (t) => setState(() => ai[1] = !ai[1]),
        ));

    return AlertDialog(
      title: Text(getLang('titleSetupGame')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(flex: 4, child: Text(getLang('pmtPlayer1'))),
              Expanded(flex: 1, child: Text(getLang('pmtAI')))
            ],
          ),
          Row(
            children: [username0Field, ai0Checkbox],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(flex: 4, child: Text(getLang('pmtPlayer2'))),
              Expanded(flex: 1, child: Text(getLang('pmtAI')))
            ],
          ),
          Row(
            children: [username1Field, ai1Checkbox],
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
    Navigator.push(
        context,
        genRoute(GameScreen(
          game: Game(
            Board(),
            _playerList,
          ),
        )));
  }

  /// _validateUsername validates a provided username [iusername] and returns the validated
  /// username. This validation includes validating/censoring/cleaning and ensuring the username
  /// does not extend past the max length.
  String _validateUsername(String iusername) {
    const int maxUsernameLength = 11;
    return iusername.length > maxUsernameLength
        ? iusername.substring(0, maxUsernameLength)
        : iusername;
  }

  /// get _playerList returns a list of the players for the game. If the AI option is checked for a
  /// specific player, that player will be a computer player, otherwise it will be a user player.
  List<Player> get _playerList {
    // The computer and non computer player for player 0
    var computerPlayer0 = ComputerPlayer(
      username[0],
      Image.asset(
        'assets/coins/coin_pixel.png',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.none,
        width: double.infinity,
      ),
      Colors.red,
    );

    var player0 = Player(
      username[0],
      Image.asset(
        'assets/coins/coin_pixel.png',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.none,
        width: double.infinity,
      ),
      Colors.red,
    );

    // The computer and non computer player for player 1
    var computerPlayer1 = ComputerPlayer(
      username[1],
      Image.asset(
        'assets/coins/coin_pixel.png',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.none,
        width: double.infinity,
      ),
      Colors.blue,
    );

    var player1 = Player(
      username[1],
      Image.asset(
        'assets/coins/coin_pixel.png',
        fit: BoxFit.cover,
        filterQuality: FilterQuality.none,
        width: double.infinity,
      ),
      Colors.blue,
    );

    // Returns a list of player 0 and player 1. Returns the computer player if needed, otherwise the
    // non computer players.
    return [
      ai[0] ? computerPlayer0 : player0,
      ai[1] ? computerPlayer1 : player1,
    ];
  }
}
