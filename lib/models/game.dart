import 'pos.dart';

/// The state of the game
enum GameStatus {
  draw,
  player1,
  player2,
  playing,
  idle,
}

/// Game object, is the state of the current game
class Game {
  static const int empty = 0;
  static const int p1 = 1; // 1 => 11
  static const int p2 = 2; // 2 => 12

  // Convert a given player id to its super version (last played)
  static int sup(int id) => id < 10 && id > 0 ? id + 10 : id;
  // Convert a given player id to its sub version (normal)
  static int sub(int id) => id > 10 ? id - 10 : id;

  /// A matrix storing the items on the board
  List<List<int>> board;

  /// The current player (1 or 2)
  int currentPlayer;

  /// Game status
  GameStatus status;

  String player1Name = '';
  String player2Name = '';

  /// Constructor
  Game({int width = 7, int height = 6})
      : board = List.generate(width, (_) => List.filled(height, 0)),
        currentPlayer = 1,
        status = GameStatus.idle;

  /// Returns the json objecct for the game
  Map<String, dynamic> toJson() => {
        'board': board,
        'currentPlayer': currentPlayer,
        'status': status.index,
        'p1n': player1Name,
        'p2n': player2Name,
      };

  // From json
  Game.fromJson(Map<String, dynamic> json)
      : board = (json['board'] as List<dynamic>).map<List<int>>((item) {
          return (item as List<dynamic>).map<int>((e) => e as int).toList();
        }).toList(),
        currentPlayer = json['currentPlayer'],
        status = GameStatus.values[json['status']],
        player1Name = json['p1n'],
        player2Name = json['p2n'];

  // Validation check to make sure the given position is in bounds of the board
  bool isInBounds(Pos pos) {
    int x = pos.x;
    int y = pos.y;
    // Out of bounds - return false
    if (x < 0 || x >= board.length || y < 0 || y >= board[x].length) {
      return false;
    }
    return true;
  }

  /// Returns true if the given location on the board is empty (0), false
  /// otherwise
  bool isPlayable(Pos pos) {
    // Out of bounds check
    if (!isInBounds(pos)) return false;
    int x = pos.x;
    int y = pos.y;
    // Location is not empty
    if (board[x][y] != 0) {
      return false;
    }
    // Location is next to last played
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        // If current tile, continue
        if (i == 0 && j == 0) continue;
        // If the adjacent tile is the super version
        if (isInBounds(Pos(x: x + i, y: y + j)) &&
            board[x + i][y + j] == sup(currentPlayer)) {
          return false;
        }
      }
    }
    // Passed all fail conditions, return true
    return true;
  }

  void updateStatus() {
    // Keep track of if there are still playable tiles
    bool playable = false;
    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
        // If there is a playable tile, track it so the game does not end in a
        // draw
        if (!playable && isPlayable(Pos(x: x, y: y))) playable = true;
        // Check for row win
        if (_isFourInARow(Pos(x: x, y: y), 1, 0)) {
          board[x][y] = board[x + 1][y] =
              board[x + 2][y] = board[x + 3][y] = sup(board[x][y]);
          status =
              sub(board[x][y]) == p1 ? GameStatus.player1 : GameStatus.player2;
          return;
        }
        // Check for column
        if (_isFourInARow(Pos(x: x, y: y), 0, 1)) {
          board[x][y] = board[x][y + 1] =
              board[x][y + 2] = board[x][y + 3] = sup(board[x][y]);
          status =
              sub(board[x][y]) == p1 ? GameStatus.player1 : GameStatus.player2;
          return;
        }
        // Check for diag right
        if (_isFourInARow(Pos(x: x, y: y), 1, 1)) {
          board[x][y] = board[x + 1][y + 1] =
              board[x + 2][y + 2] = board[x + 3][y + 3] = sup(board[x][y]);
          status =
              sub(board[x][y]) == p1 ? GameStatus.player1 : GameStatus.player2;
          return;
        }
        // Check for diag left
        if (_isFourInARow(Pos(x: x, y: y), -1, 1)) {
          board[x][y] = board[x - 1][y + 1] =
              board[x - 2][y + 2] = board[x - 3][y + 3] = sup(board[x][y]);
          status =
              sub(board[x][y]) == p1 ? GameStatus.player1 : GameStatus.player2;
          return;
        }
      }
    }
    // If there are no playable tiles, set status to draw
    if (!playable) {
      status = GameStatus.draw;
    }
  }

  /// Check if there are four in a row of the same player. [pos] is the starting
  /// position, and [dx] and [dy] (delta x, delta y) are the amount to change in
  /// those directions. Returns true if there are four in a row, false
  /// otherwise.
  bool _isFourInARow(Pos pos, int dx, int dy) {
    int x = pos.x;
    int y = pos.y;
    // Boundary check for starting, and make sure starting is actually a player
    // tile
    if (!isInBounds(pos) || board[x][y] == empty) return false;
    // For every item in the row/col/diag of 4
    for (int i = 1; i < 4; i++) {
      // Set the check x and check y values
      int cx = x + dx * i;
      int cy = y + dy * i;
      // If cx,cy is out of bounds, or cx,cy is not the same player as x,y then
      // its not four in a row, return false
      if (!isInBounds(Pos(x: cx, y: cy)) ||
          sub(board[x][y]) != sub(board[cx][cy])) {
        return false;
      }
    }
    // Otherwise return true
    return true;
  }

  /// Starts the game by setting the status to playing from idle. Returns true
  /// if the status is set, false otherwise.
  bool startGame() {
    if (status != GameStatus.idle) return false;
    status = GameStatus.playing;
    return true;
  }

  /// Unset the super for the current player. This is run before the new super
  /// tile is played.
  void _unsetSuper() {
    // Go through every tile on the board
    for (int x = 0; x < board.length; x++) {
      for (int y = 0; y < board[x].length; y++) {
        // Unset super tiles for current player
        if (board[x][y] == sup(currentPlayer)) board[x][y] = sub(currentPlayer);
      }
    }
  }

  bool play(Pos pos) {
    // Check if game is in playing status
    if (status != GameStatus.playing) return false;

    // Check if the given tile is playable
    if (!isPlayable(pos)) return false;

    // Unset any previous super/last play tiles for current player
    _unsetSuper();

    // Set the play
    board[pos.x][pos.y] = sup(currentPlayer);

    // Cycle player
    currentPlayer = nextPlayer();

    // Update the game status/check for a win/end condition
    updateStatus();

    // Return true, the play was a success
    return true;
  }

  int nextPlayer() {
    return (currentPlayer % 2) + 1;
  }
}
