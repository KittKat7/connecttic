import 'dart:math';

import 'package:connecttic/models/game.dart';

import 'game_manager.dart';
import 'pos.dart';

enum PlayerLevel { player, cpu1, cpu2, cpu3 }

class Player {
  PlayerLevel level;

  Player({required this.level});

  void computerPlay(GameManager gm) {
    bool played = false;
    int mw = gm.width;
    int mh = gm.height;

    while (!played && gm.status == GameStatus.playing) {
      int tx = Random().nextInt(mw);
      int ty = Random().nextInt(mh);

      played = gm.play(Pos(x: tx, y: ty), isCPU: true);
    }
  }
}
