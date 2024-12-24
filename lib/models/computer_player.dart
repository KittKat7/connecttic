import 'dart:math';

import 'package:kittkatflutterlibrary/lang/kkfl_lang.dart';

import 'game.dart';
import 'player.dart';
import 'board.dart';

class ComputerPlayer extends Player {
  int level;
  ComputerPlayer(super.username, super.tile, [super.color, this.level = 1]);

  static const int secondsDelay = 1;
  static List<String> computerLevels = [
    getLang("pmtCpuLvl0"),
    getLang("pmtCpuLvl1"),
  ];

  void computerPlay(Game game) async {
    await Future.delayed(const Duration(seconds: secondsDelay));
    Board board = game.board;
    Random ran = Random();
    while (!game.play(ran.nextInt(board.width), ran.nextInt(board.height)) &&
        !game.isEnded) {}
  }
}
