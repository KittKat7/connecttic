import 'game.dart';
import 'pos.dart';

enum GameType { local, computer, remote }

class GameManager {
  static GameManager? gm;

  static GameManager getGM() {
    return gm!;
  }

  Game game;
  GameManager(this.type) : game = Game() {
    if (type == GameType.local) game.status = GameStatus.playing;
  }

  GameType type;
  int get width => game.board.length;
  int get height => game.board[0].length;
  int getItem(Pos pos) => game.board[pos.x][pos.y];
  int get currentPlayer => game.currentPlayer;
  GameStatus get status => game.status;

  bool play(Pos pos) {
    if (game.status != GameStatus.playing) return false;
    // Local game
    if (type == GameType.local) {
      return game.play(pos);
    }
    return false;
  }
}
