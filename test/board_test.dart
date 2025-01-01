import 'package:connecttic/lang/en_us.dart' as en_us;
import 'package:connecttic/models/board.dart';
import 'package:connecttic/models/game.dart';
import 'package:connecttic/models/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kittkatflutterlibrary/lang/kkfl_lang.dart';

/// Run tests related to the game board.
void main() {
  test("Test incomplete game draw cases", testIncompleteDraw);
  test("Check draw conditions", testBoardDrawStateDetected);
  test("Check set last play", testBlockAroundLastPlay);
  test("Check equals comparison", testEqual);
  test("Test json to and from", testToFromJson);
}

/// Test for incomplete game draws, IE there are tiles no playable tiles and blockers on the board.
void testIncompleteDraw() {
  WidgetsFlutterBinding.ensureInitialized();
  setLangMap(en_us.en_us);

  Player p1 = Player(const Icon(Icons.abc));
  Player p2 = Player(const Icon(Icons.abc));
  Board board = Board(7, 6);
  Game game = Game(board, PlayerList.fromList([p1, p2]));

  List<List<int>> plays = [
    // First row
    [0, 0],
    [1, 0],
    [2, 0],
    [3, 0],
    [4, 0],
    [5, 0],
    [6, 0],
    // Second row
    [1, 1],
    [2, 1],
    [3, 1],
    [4, 1],
    [5, 1],
    [6, 1],
    // Third row
    [1, 2],
    [2, 2],
    [3, 2],
    [4, 2],
    [5, 2],
    [6, 2],
    // Fourth row
    [0, 3],
    [1, 3],
    [2, 3],
    [3, 3],
    [4, 3],
    [5, 3],
    [6, 3],
    // Fill in 0, 1
    [0, 1],
    // Fifth row
    [0, 4],
    [1, 4],
    [2, 4],
    [3, 4],
    [4, 4],
    // Fill 0, 2
    [0, 2],
    // Sixth row
    [0, 5],
    [1, 5],
    [2, 5],
    [3, 5],
    [4, 5],
    // Final square
    [5, 4],
    [6, 4],
  ];

  for (int i = 0; i < plays.length; i++) {
    game.play(plays[i][0], plays[i][1]);
  }

  expect(board.hasOpenTile(), false);
}

/// Checks to make sure that the setLastPlay blocks the empty tiles around that last play tile.
void testBlockAroundLastPlay() {
  Board board = Board();
  board.setLastPlay(2, 2, true);
  for (int i = 1; i < 4; i++) {
    for (int j = 1; j < 4; j++) {
      if (i == 2 && j == 2) continue;
      expect(board.get(i, j) == -1, true);
    }
  }
}

/// Checks to ensure that a tie where EVERY tile is taken by a player is detected.
void testBoardDrawStateDetected() {
  Board board = Board();
  for (int x = 0; x < board.width; x++) {
    for (int y = 0; y < board.height; y++) {
      board.set(x, y, -1);
    }
  }
  expect(board.hasOpenTile(), false);
}

void testEqual() {
  Board board1 = Board();
  board1.set(0, 1, 1);
  board1.set(2, 1, 1);
  board1.set(4, 1, 1);

  Board board2 = Board();
  board2.set(0, 1, 1);
  board2.set(2, 1, 1);
  board2.set(4, 1, 1);

  expect(board1, board2);
}

void testToFromJson() {
  Board board1 = Board();
  board1.set(0, 0, 1);
  board1.set(1, 0, 1);
  board1.set(2, 0, 2);
  board1.set(3, 0, 1);

  String json = board1.toJson();
  Board board2 = Board.fromJson(json);

  expect(json, board2.toJson());

  expect(board1, board2);
}
