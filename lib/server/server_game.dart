import 'dart:async';

import 'package:connecttic/models/game_manager.dart';
import 'package:connecttic/models/player.dart';

class ServerGame {
  GameManager gm;
  String hash;
  String user1;
  String? user2;

  Timer timerout;

  ServerGame({
    required this.hash,
    required this.user1,
    required Function() timeout,
  })  : gm = GameManager(GameType.local,
            player1: Player(level: PlayerLevel.player),
            player2: Player(level: PlayerLevel.player)),
        timerout = Timer(
          const Duration(minutes: 2),
          () => timeout(),
        );
}
