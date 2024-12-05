import 'dart:math';

import 'game.dart';
import 'player.dart';
import 'board.dart';

class ComputerPlayer extends Player {
  ComputerPlayer(super.username, super.tile, [super.color]);

  static const int secondsDelay = 1;

  void computerPlay(Game game) async {
    await Future.delayed(const Duration(seconds: secondsDelay));
    Board board = game.board;
    Random ran = Random();
    while (!game.play(ran.nextInt(board.width), ran.nextInt(board.height)) &&
        !game.isEnded) {}
  }
}
