import 'dart:async';

import 'package:connecttic/models/board.dart';
import 'package:connecttic/models/player.dart';
import 'package:flutter/material.dart';

/// Game class manages the game state/ players, current turn, and win status.
class Game {
  Board board;
  List<Player> players;
  bool isEnded = false;

  Timer? _timer;
  final ValueNotifier<int> timeNotifier;

  /// Tracks the current player.
  Player _currentPlayer;

  /// Constructor
  Game(this.board, this.players)
      : _currentPlayer = players[0],
        timeNotifier = ValueNotifier<int>(0) {
    // Initiate the timer
    _timer = Timer.periodic(const Duration(seconds: 1), (time) {
      // If the game has ended, stop the timer and return
      if (isEnded) {
        _timer?.cancel();
        return;
      }
      timeNotifier.value++;
    });
  }

  void dispose() {
    _timer?.cancel();
    timeNotifier.dispose();
  }

  /// Returns the current player (the player whose turn it is).
  Player getCurrentPlayer() {
    return _currentPlayer;
  }

  /// Cycles [_currentPlyer] to be the next player in the list.
  void iterateCurrentPlayer() {
    int index = players.indexOf(_currentPlayer) + 1;
    if (index >= players.length) index = 0;
    _currentPlayer = players[index];
  }

  /// Manages the functions needed to be run when a player plays. This method runs when a player
  /// tries to play.
  void play(int x, int y) {
    // If the selected tile is NOT an EmptyTile, its either a blocker or a player, return and don't
    // complete the play.
    if (isEnded || board.get(x, y) != null) return;

    // If the current players last x and y are not negative (they have played before) then un
    // highlight their last play and unset their last play.
    if (_currentPlayer.lastx > -1 && _currentPlayer.lasty > -1) {
      board.setHighlight(_currentPlayer.lastx, _currentPlayer.lasty, false);
      board.setLastPlay(_currentPlayer.lastx, _currentPlayer.lasty, false);
    }

    // Set the tile at the play location to be a copy of the player's tile.
    board.set(x, y, _currentPlayer);

    // If the board finds a win condition, mark the game as ended and skip the rest of the play
    // functions.
    if (board.gameIsWon()) {
      isEnded = true;
      return;
    }

    // Check if their are playable tiles left on the board. If there are no more playable tiles, the
    // game has ended in a draw.
    if (!board.hasOpenTile()) {
      isEnded = true;
      return;
    }

    // Set the play to be highlighted, update the last x and y, and iterate the current player.
    board.setHighlight(x, y, true);
    _currentPlayer.lastx = x;
    _currentPlayer.lasty = y;
    iterateCurrentPlayer();

    // If the new current player has played previously, mark their last play by putting blockers
    // around it.
    if (_currentPlayer.lastx > -1 && _currentPlayer.lasty > -1) {
      board.setLastPlay(_currentPlayer.lastx, _currentPlayer.lasty, true);
    }
  }
}
