import 'player.dart';
import 'game.dart';
import 'pos.dart';

enum GameType { local, remote }

class GameManager {
  static GameManager? gm;

  static GameManager getGM() {
    return gm!;
  }

  Game game;
  GameType type;
  void Function()? updateCallback;
  int get width => game.board.length;
  int get height => game.board[0].length;
  int getItem(Pos pos) => game.board[pos.x][pos.y];
  int get currentPlayer => game.currentPlayer;
  GameStatus get status => game.status;
  Player player1;
  Player player2;

  GameManager(this.type, {required this.player1, required this.player2})
      : game = Game() {
    // Local play
    if (type == GameType.local) {
      game.status = GameStatus.playing;
      if (player1.level != PlayerLevel.player) {
        player1.computerPlay(this);
      }
    }
    // Remote play
    else if (type == GameType.remote) {
      game.status = GameStatus.idle;
    }
  }

  bool play(Pos pos, {bool isCPU = false}) {
    bool played = false;

    if (game.status != GameStatus.playing) {
      return false;
    }

    // Local game
    if (type == GameType.local) {
      Player cPlayer = game.currentPlayer == Game.p1 ? player1 : player2;
      Player nPlayer = game.nextPlayer() == Game.p1 ? player1 : player2;

      // Return false if its a CPU turn and a player played
      if (cPlayer.level != PlayerLevel.player && !isCPU) {
        return false;
      }

      // Whether the play was successful
      played = game.play(pos);

      if (played && nPlayer.level != PlayerLevel.player) {
        Future.delayed(const Duration(seconds: 1), () {
          nPlayer.computerPlay(this);
        });
      }
    }

    if (played) {
      callUpdateCallback();
    }

    return played;
  }

  /// Calls the updateCallback function if its not null, and returns true.
  /// Else returns false.
  bool callUpdateCallback() {
    if (updateCallback != null) {
      updateCallback!();
      return true;
    }
    return false;
  }
}
