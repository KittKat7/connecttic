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
            children: [
              Expanded(
                  flex: 4,
                  child: TextFormField(
                    initialValue: username[0],
                    onChanged: (v) => username[0] = v,
                  )),
              Expanded(
                  flex: 1,
                  child: Checkbox(
                    value: ai[0],
                    onChanged: (t) => setState(() => ai[0] = !ai[0]),
                  ))
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(flex: 4, child: Text(getLang('pmtPlayer2'))),
              Expanded(flex: 1, child: Text(getLang('pmtAI')))
            ],
          ),
          Row(
            children: [
              Expanded(
                  flex: 4,
                  child: TextFormField(
                    initialValue: username[1],
                    onChanged: (v) => username[1] = v,
                  )),
              Expanded(
                  flex: 1,
                  child: Checkbox(
                    value: ai[1],
                    onChanged: (t) => setState(() => ai[1] = !ai[1]),
                  ))
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
              Navigator.pop(context);
              Navigator.push(
                  context,
                  genRoute(GameScreen(
                    game: Game(
                      Board(),
                      [
                        ai[0]
                            ? ComputerPlayer(
                                username[0],
                                Image.asset(
                                  'assets/coins/coin_pixel.png',
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.none,
                                  width: double.infinity,
                                ),
                                Colors.red,
                              )
                            : Player(
                                username[0],
                                Image.asset(
                                  'assets/coins/coin_pixel.png',
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.none,
                                  width: double.infinity,
                                ),
                                Colors.red,
                              ),
                        ai[1]
                            ? ComputerPlayer(
                                username[1],
                                Image.asset(
                                  'assets/coins/coin_pixel.png',
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.none,
                                  width: double.infinity,
                                ),
                                Colors.blue,
                              )
                            : Player(
                                username[1],
                                Image.asset(
                                  'assets/coins/coin_pixel.png',
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.none,
                                  width: double.infinity,
                                ),
                                Colors.blue,
                              ),
                      ],
                    ),
                  )));
            },
            child: Text(getLang('btnConfirm'))),
      ],
    );
  }
}
