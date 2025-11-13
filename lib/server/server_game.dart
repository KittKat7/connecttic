import 'dart:async';

import 'package:connecttic/models/game_manager.dart';
import 'package:connecttic/models/player.dart';
import 'package:connecttic/models/pos.dart';

// ignore: constant_identifier_names
const TIMEOUT_DURATION = Duration(seconds: 10);

class ServerGame {
  /// The games game manager
  GameManager gm;

  /// Hash for the game
  String hash;

  /// Hash for user1
  String user1;

  /// Hash for user2
  String? user2;

  /// Called when the [timerout] timer activates
  void Function() timeoutCallback;

  /// Used to timeout the game after no activity
  Timer timerout;

  /// Constructor
  /// Create [gm] as type [GameType.local] as it is local to the server.
  /// Platers interacting with it will be using [GameType.remote].
  ServerGame({
    required this.hash,
    required this.user1,
    required this.timeoutCallback,
  })  : gm = GameManager(GameType.local,
            player1: Player(level: PlayerLevel.player),
            player2: Player(level: PlayerLevel.player)),
        timerout = Timer(
          TIMEOUT_DURATION,
          timeoutCallback,
        );

  /// Handles plays for server games. Passes the position to the [GameManager]
  /// and resets the timeout clock [timerout]. Returns the response from calling
  /// `gm.play()`.
  bool play(Pos pos) {
    // Reset the timer
    timerout = Timer(
      TIMEOUT_DURATION,
      timeoutCallback,
    );
    return gm.play(pos);
  }
}
