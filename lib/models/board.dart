import 'package:connecttic/models/game_object.dart';
import 'package:connecttic/models/player.dart';
import 'package:flutter/material.dart';

/// The Board object keeps track of where the player plays by using a,b,c,..., to track player
/// tokens on the board, A,B,C,..., to track the last played token, "-" to track blocked tiles and
/// "" (empty string) for empty tiles.
class Board {
  /// Width
  int width;

  /// Height
  int height;

  /// Board[w][h]
  final List<List<GameObject?>> _board;
  List<List<bool>> _isHighlighted;

  /// Board constructor
  Board([int w = 7, int h = 6])
      : width = w,
        height = h,
        _isHighlighted = [],
        _board = [] {
    for (int i = 0; i < width; i++) {
      List<GameObject?> tmp = [];
      for (int j = 0; j < height; j++) {
        tmp.add(null);
      }
      _board.add(tmp);
    }
    _isHighlighted =
        List.generate(width, (_) => List.generate(height, (_) => false));
  }

  /// get(x,y) returns the string at the given x (width) and y (height) position.
  GameObject? get(int x, int y) {
    return _board[x][y];
  }

  Widget getTile(int x, int y) {
    if (get(x, y) == null) return const SizedBox();
    return _isHighlighted[x][y]
        ? get(x, y)!.getBigTile()
        : get(x, y)!.getTile();
  }

  /// set(x,y,item) sets the tile at _board[x][y] to be item.
  void set(int x, int y, GameObject? item) {
    _board[x][y] = item;
  }

  /// Blocks a given tile if the tile is empty, IE changed "" to "-".\
  void _block(int x, int y) {
    if (get(x, y) == null) set(x, y, BlockerObject());
  }

  /// Unblocks a given tile if the tile is blocked, IE changes "-" to "".
  void _unblock(int x, int y) {
    if (get(x, y) is BlockerObject) set(x, y, null);
  }

  /// This method sets the tile at x y to be the last played piece and will mark out open tiles
  /// around that location.
  void setLastPlay(int x, int y, status) {
    // For every tile around the given tile, if that tile is empty, set it to be a "-"
    for (int i = x - 1; i <= x + 1; i++) {
      if (i < 0 || i >= width) continue;
      for (int j = y - 1; j <= y + 1; j++) {
        if (j < 0 || j >= height) continue;

        status ? _block(i, j) : _unblock(i, j);
      }
    }
  }

  /// Capitalizes the item at x y.
  void setHighlight(int x, int y, status) {
    _isHighlighted[x][y] = status;
  }

  /// Checks whether a player has won the game. If so, return true, otherwise, return false. A
  /// player can win by getting four tiles in a row, column, down diagonal, or up diagonal.
  /// If a win condition is found, return true, and highlight the four in a row winning tiles.
  bool gameIsWon() {
    // For every tile in the board, (for every x: for every y: etc...).
    for (int x = 0; x < _board.length; x++) {
      for (int y = 0; y < _board[x].length; y++) {
        // If the tile at x y is empty, not a player tile, continue past this tile.
        if (_board[x][y] is! Player) continue;
        // Check if the player has four tiles in a row.
        if (_checkWinRow(x, y)) {
          for (int i = 0; i < 4; i++) {
            setHighlight(x + i, y, true);
          }
          return true;
        }
        // Check if the player has four tiles in a down diagonal.
        else if (_checkWinDiag(x, y)) {
          for (int i = 0; i < 4; i++) {
            setHighlight(x + i, y + i, true);
          }
          return true;
        }
        // Check if the player has four tiles in an up diagonal.
        else if (_checkWinDiagR(x, y)) {
          for (int i = 0; i < 4; i++) {
            setHighlight(x + i, y - i, true);
          }
          return true;
        }
        // Check if the player has four tiles in a column.
        else if (_checkWinCol(x, y)) {
          for (int i = 0; i < 4; i++) {
            setHighlight(x, y + i, true);
          }
          return true;
        }
      }
    }
    return false;
  }

  /// Returns true if there are any empty tiles on the board, otherwise, false if the board is full
  /// of player tiles or blocker tiles.
  bool hasOpenTile() {
    for (int x = 0; x < _board.length; x++) {
      for (int y = 0; y < _board[x].length; y++) {
        if (_board[x][y] == null) return true;
      }
    }
    return false;
  }

  /// Checks and returns true if a player has four pieces in a row.
  bool _checkWinRow(int x, int y) {
    for (int i = 0; i < 4; i++) {
      if (x + i >= _board.length) return false;
      if (_board[x][y] != _board[x + i][y]) return false;
    }
    return true;
  }

  /// Checks and returns true if a player has four pieces in a down diagonal (l to r).
  bool _checkWinDiag(int x, int y) {
    for (int i = 0; i < 4; i++) {
      if (x + i >= _board.length || y + i >= _board[x + i].length) return false;
      if (_board[x][y] != _board[x + i][y + i]) return false;
    }
    return true;
  }

  /// Checks and returns true if a player has four pieces in a up diagonal (l to r).
  bool _checkWinDiagR(int x, int y) {
    for (int i = 0; i < 4; i++) {
      if (x + i >= _board.length || y - i <= 0) return false;
      if (_board[x][y] != _board[x + i][y - i]) return false;
    }
    return true;
  }

  /// Checks and returns true if a player has four pieces in a column.
  bool _checkWinCol(int x, int y) {
    for (int i = 0; i < 4; i++) {
      if (y + i >= _board[x].length) return false;
      if (_board[x][y] != _board[x][y + i]) return false;
    }
    return true;
  }
}
