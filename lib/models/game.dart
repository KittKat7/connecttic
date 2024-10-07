import 'package:connecttic/models/board.dart';
import 'package:connecttic/models/player.dart';

/// Game class manages the game state/ players, current turn, and win status.
class Game {
  Board board;
  List<Player> players;

  /// Tracks the current player.
  Player _currentPlayer;

  /// Constructor
  Game(this.board, this.players) : _currentPlayer = players[0];

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

  void play(int x, int y) {
    if (board.get(x, y).isNotEmpty) return;
    if (_currentPlayer.lastx > -1 && _currentPlayer.lasty > -1) {
      board.highlight(_currentPlayer.lastx, _currentPlayer.lasty, true);
      board.setLastPlay(_currentPlayer.lastx, _currentPlayer.lasty, true);
    }
    board.set(x, y, _currentPlayer.marker.toUpperCase());
    _currentPlayer.lastx = x;
    _currentPlayer.lasty = y;
    iterateCurrentPlayer();
    if (_currentPlayer.lastx > -1 && _currentPlayer.lasty > -1) {
      board.setLastPlay(_currentPlayer.lastx, _currentPlayer.lasty);
    }
  }
}
