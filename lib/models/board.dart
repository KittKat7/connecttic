import 'dart:convert';

/// The Board object keeps track of where the player plays by using a,b,c,..., to track player
/// tokens on the board, A,B,C,..., to track the last played token, "-" to track blocked tiles and
/// "" (empty string) for empty tiles.
class Board {
  /// Width
  int width;

  /// Height
  int height;

  /// Board[w][h]
  List<List<int?>> _board;

  /// Board constructor
  Board([int w = 7, int h = 6])
      : width = w,
        height = h,
        _board = [] {
    // Initiate [_board] with null
    for (int i = 0; i < width; i++) {
      List<int?> tmp = [];
      for (int j = 0; j < height; j++) {
        tmp.add(null);
      }
      _board.add(tmp);
    }
  }

  /// get(x,y) returns the string at the given x (width) and y (height) position.
  int? get(int x, int y) {
    return _board[x][y];
  }

  /// set(x,y,item) sets the tile at _board[x][y] to be item.
  void set(int x, int y, int? item) {
    _board[x][y] = item;
  }

  /// Blocks a given tile if the tile is empty, IE changed "" to "-".\
  void _block(int x, int y) {
    if (get(x, y) == null) set(x, y, -1);
  }

  /// Unblocks a given tile if the tile is blocked, IE changes "-" to "".
  void _unblock(int x, int y) {
    if (_isBlocker(get(x, y))) set(x, y, null);
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

  bool _isPlayer(int? item) {
    return item == null
        ? false
        : item < 0
            ? false
            : true;
  }

  bool _isBlocker(int? item) {
    return item == -1;
  }

  /// Checks whether a player has won the game. If so, return true, otherwise, return false. A
  /// player can win by getting four tiles in a row, column, down diagonal, or up diagonal.
  /// If a win condition is found, return true, and highlight the four in a row winning tiles.
  List<List<int>>? gameIsWon() {
    List<List<int>> winset = [];
    // For every tile in the board, (for every x: for every y: etc...).
    for (int x = 0; x < _board.length; x++) {
      for (int y = 0; y < _board[x].length; y++) {
        // If the tile at x y is empty, not a player tile, continue past this tile.
        if (!_isPlayer(_board[x][y])) continue;
        // Check if the player has four tiles in a row.
        if (_checkWinRow(x, y)) {
          winset = [];
          for (int i = 0; i < 4; i++) {
            winset.add([x + i, y]);
          }
          return winset;
        }
        // Check if the player has four tiles in a down diagonal.
        else if (_checkWinDiag(x, y)) {
          winset = [];
          for (int i = 0; i < 4; i++) {
            winset.add([x + i, y + i]);
          }
          return winset;
        }
        // Check if the player has four tiles in an up diagonal.
        else if (_checkWinDiagR(x, y)) {
          winset = [];
          for (int i = 0; i < 4; i++) {
            winset.add([x + i, y - i]);
          }
          return winset;
        }
        // Check if the player has four tiles in a column.
        else if (_checkWinCol(x, y)) {
          winset = [];
          for (int i = 0; i < 4; i++) {
            winset.add([x, y + i]);
          }
          return winset;
        }
      }
    }
    return null;
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

  String toJson() {
    List<dynamic> boardData = [];
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        boardData.add(_board[i][j]);
      }
    }
    Map<String, dynamic> mapData = {
      "w": width,
      "h": height,
      "b": json.encode(boardData),
    };
    return json.encode(mapData);
  }

  static Board fromJson(String jsonData) {
    Map<String, dynamic> mapData = json.decode(jsonData);
    int width = mapData["w"];
    int height = mapData["h"];
    List<dynamic> boardData = json.decode(mapData["b"]);

    List<List<int?>> boardArray = [];
    int a = 0;
    for (int i = 0; i < width; i++) {
      List<int?> tmp = [];
      for (int j = 0; j < height; j++) {
        tmp.add(boardData[a]);
        a++;
      }
      boardArray.add(tmp);
    }
    Board board = Board(width, height);
    board._board = boardArray;
    return board;
  }

  @override
  bool operator ==(Object other) {
    if (other is! Board) return false;
    if (width != other.width) return false;
    if (height != other.height) return false;
    for (int i = 0; i < width; i++) {
      for (int j = 0; j < height; j++) {
        if (_board[i][j] != other._board[i][j]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => toJson().hashCode;
}
