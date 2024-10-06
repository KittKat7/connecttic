/// The Board object keeps track of where the player plays by using a,b,c,..., to track player
/// tokens on the board, A,B,C,..., to track the last played token, "-" to track blocked tiles and
/// "" (empty string) for empty tiles.
class Board {
  /// Width
  int width;

  /// Height
  int height;

  /// Board[w][h]
  final List<List<String>> _board;

  /// Board constructor
  Board([int w = 7, int h = 6])
      : width = w,
        height = h,
        _board = List.filled(w, List.filled(h, ""));

  /// get(x,y) returns the string at the given x (width) and y (height) position.
  String get(int x, int y) {
    return _board[x][y];
  }

  /// set(x,y,item) sets the tile at _board[x][y] to be item.
  void set(int x, int y, String item) {
    _board[x][y] = item;
  }

  /// Blocks a given tile if the tile is empty, IE changed "" to "-".\
  void _block(int x, int y) {
    if (get(x, y).isEmpty) set(x, y, "-");
  }

  /// Unblocks a given tile if the tile is blocked, IE changes "-" to "".
  void _unblock(int x, int y) {
    if (get(x, y) == "-") set(x, y, "");
  }

  /// This method sets the tile at x y to be the last played piece and will mark out open tiles
  /// around that location.
  void setLastPlay(int x, int y, [bool unset = false]) {
    // For every tile around the given tile, if that tile is empty, set it to be a "-"
    for (int i in [x - 1, x + 1]) {
      if (i < 0 || i >= width) continue;

      for (int j in [y - 1, y + 1]) {
        if (j < 0 || j >= height) continue;

        !unset ? _block(i, j) : _unblock(i, j);
      }
    }
  }
}
