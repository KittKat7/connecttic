import 'dart:async';

import 'package:connecttic/models/audio_player.dart';
import 'package:connecttic/models/board.dart';
import 'package:connecttic/models/computer_player.dart';
import 'package:connecttic/models/player.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

/// Game class manages the game state/ players, current turn, and win status.
class Game {
  /// The board which is used for this game.
  Board board;

  /// The list of players in the game.
  List<Player> players;

  /// Bool flag, true if the game has ended.
  bool isEnded = false;

  Timer? _timer;
  final ValueNotifier<int> timeNotifier;

  void Function()? onEndCallback;
  void Function()? onUpdateBoard;

  /// Tracks the current player.
  Player _currentPlayer;

  final Map<String, String> _gameInfo;

  /// Constructor
  Game(this.board, this.players)
      : _currentPlayer = players[0],
        timeNotifier = ValueNotifier<int>(0),
        _gameInfo = {},
        onEndCallback = null {
    // Initiate the timer
    _timer = Timer.periodic(const Duration(seconds: 1), _onTimeUpdate);
    if (!isEnded && _currentPlayer is ComputerPlayer) {
      (_currentPlayer as ComputerPlayer).computerPlay(this);
    }
  }

  /// The function to be run every second when the timer updates.
  void _onTimeUpdate(time) {
    // If the game has ended, stop the timer and return
    if (isEnded) {
      _timer?.cancel();
      return;
    }
    timeNotifier.value++;
  }

  /// Dispose of the game, cancel the timer and dispose of the time notifier.
  void dispose() {
    _timer?.cancel();
    timeNotifier.dispose();
    isEnded = true;
  }

  /// Sets the callback function which is run when the game ends.
  void setOnEndCallback(void Function() func) {
    onEndCallback = func;
  }

  /// Sets the function which is run when the board is updated. This should be a setstate function
  /// which will be called so the displayed board will be updated.
  void setOnUpdateBoard(void Function() func) {
    onUpdateBoard = func;
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
  /// @returns true if the play is successful
  bool play(int x, int y) {
    // If the selected tile is NOT an EmptyTile, its either a blocker or a player, return and don't
    // complete the play.
    if (isEnded || board.get(x, y) != null) return false;

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
      onGameEnd(_currentPlayer);
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
    AppAudio.getInstance().playEffect(AppAudio.effectPop);

    if (!isEnded && _currentPlayer is ComputerPlayer) {
      (_currentPlayer as ComputerPlayer).computerPlay(this);
    }
    if (onUpdateBoard != null) onUpdateBoard!();

    // Check if their are playable tiles left on the board. If there are no more playable tiles, the
    // game has ended in a draw.
    if (!board.hasOpenTile()) {
      isEnded = true;
      onGameEnd(null);
    }
    return true;
  }

  void onGameEnd(Player? winner) {
    _gameInfo["winner"] = winner?.username ?? getLang("pmtDraw");
    int gameTime = timeNotifier.value;
    _gameInfo["time"] = getLang('mscMinSec', [
      (gameTime ~/ 60).toString().padLeft(2, '0'),
      (gameTime % 60).toString().padLeft(2, '0')
    ]);

    if (onEndCallback != null) onEndCallback!();
  }

  Map<String, String> getGameInfo() {
    return Map.from(_gameInfo);
  }
}
