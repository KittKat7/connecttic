import 'package:connecttic/widgets/gameednpopup_widget.dart';
import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../models/audio_player.dart';
import '../models/game.dart';
import '../models/game_manager.dart';
import '../models/pos.dart';

/// This widget displays the game board.
class GameBoard extends StatelessWidget {
  static const EmptyTile = SizedBox();
  // TODO
  static const BlockerTile = Icon(Icons.clear);
  static const Player1Tile = Icon(Icons.circle_outlined);
  static const Player2Tile = Icon(Icons.square_outlined);
  static const Player1TileSup = Icon(Icons.circle);
  static const Player2TileSup = Icon(Icons.square);

  /// The board which should be displayed.
  final GameManager gameManager;
  final Function() changeCallback;

  /// Const constructor.
  const GameBoard(
      {super.key, required this.gameManager, required this.changeCallback});

  List<Widget> getWidgetList() {
    // Length x of the board
    int lx = gameManager.width;
    // Length y of the board
    int ly = gameManager.height;

    // Create empty tile list
    List<Widget> displayList = List.filled(lx * ly, EmptyTile);

    int a = 0;
    // Loop through the board to create the list
    for (int x = 0; x < lx; x++) {
      for (int y = 0; y < ly; y++) {
        // Display list location
        int dloc = lx * y + x;
        // Get the item from the location on the board
        int item = gameManager.getItem(Pos(x: x, y: y));

        if (item == Game.empty) continue;

        // What type of tile
        if (item == Game.p1) {
          // If player 1 tile
          displayList[dloc] = Player1Tile;
        } else if (item == Game.p2) {
          // If player 2 tile
          displayList[dloc] = Player2Tile;
        } else if (item == Game.sup(gameManager.currentPlayer)) {
          // Current player last player
          displayList[dloc] = gameManager.currentPlayer == Game.p1
              ? Player1TileSup
              : Player2TileSup;
          // If super tile for current player
          for (int i = -1; i <= 1; i++) {
            for (int j = -1; j <= 1; j++) {
              // Temp location
              int tloc = lx * (y + j) + (x + i);
              // If the temp location is the current location
              if ((i == 0 && j == 0) ||
                  (x + i < 0 || x + i >= lx || y + j < 0 || y + j >= ly)) {
                continue;
              }
              // If the temp location is empty, set it with a blocker
              if (displayList[tloc] == EmptyTile) {
                displayList[tloc] = BlockerTile;
              }
            }
          }
        } else if (item ==
            Game.sup(
                gameManager.currentPlayer == Game.p1 ? Game.p2 : Game.p1)) {
          displayList[dloc] = gameManager.currentPlayer == Game.p1
              ? Player2TileSup
              : Player1TileSup;
        }
        // Else, don't do anything, already empty tile
      }
    }
    return displayList;
  }

  @override
  Widget build(BuildContext context) {
    // List of all widgets on the board.
    List<Widget> tlist = getWidgetList();
    List<Widget> boardWidgetList = [];
    for (int i = 0; i < tlist.length; i++) {
      boardWidgetList.add(_BoardTile(
        onTap: () => play(
            (i % gameManager.width).toInt(), (i / gameManager.width).toInt()),
        tile: tlist[i],
      ));
    }

    // Return the widget.
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        decoration: BoxDecoration(
            border:
                Border.all(color: colorScheme(context).onSecondary, width: 4)),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: gameManager.width,
          childAspectRatio: 1.0,
          children: boardWidgetList,
        ),
      ),
    );
  }

  void play(x, y) {
    if (gameManager.play(Pos(x: x, y: y))) {
      AppAudio.getInstance().playEffect(AppAudio.effectPop);
      changeCallback();
    }
  }
}

/// Private class for tiles on the board.
class _BoardTile extends StatelessWidget {
  /// The widget for the tile.
  final Widget tile;

  /// Function to run on tap.
  final void Function() onTap;

  /// Const constructor.
  const _BoardTile({required this.tile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      child: Stack(
        children: [
          ColorFiltered(
              colorFilter: ColorFilter.mode(
                colorScheme(context).onSecondary,
                BlendMode.modulate,
              ),
              child: Image.asset(
                'assets/board_tile.png',
                fit: BoxFit.cover,
                width: double.infinity,
                filterQuality: FilterQuality.none,
              )),
          SizedBox.expand(child: FittedBox(child: tile))
        ],
      ),
      onTapInside: (event) => onTap(),
    );
  }
}
