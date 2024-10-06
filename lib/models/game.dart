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
    int index = players.indexOf(_currentPlayer);
    if (index >= players.length) index = 0;
    _currentPlayer = players[index];
  }
}
