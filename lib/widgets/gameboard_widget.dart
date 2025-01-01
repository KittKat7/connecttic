import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../models/audio_player.dart';
import '../models/computer_player.dart';
import '../models/game.dart';
import '../models/game_object.dart';
import '../models/player.dart';

/// This widget displays the game board.
class GameBoard extends StatelessWidget {
  /// The board which should be displayed.
  final Game game;

  /// The function to run when tapped/clicked.

  /// Const constructor.
  const GameBoard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    // List of all widgets on the board.
    List<Widget> boardWidgetList = [];
    // For every x and every y, add the tile to the list witht he correct widget and onTap function.
    for (int h = 0; h < game.board.height; h++) {
      for (int w = 0; w < game.board.width; w++) {
        boardWidgetList.add(
          _BoardTile(
            tile: getTileWidget(w, h),
            onTap: () => play(w, h),
          ),
        );
      }
    }
    // Return the widget.
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Container(
        decoration:
            BoxDecoration(border: Border.all(color: colorScheme(context).onSecondary, width: 4)),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: game.board.width,
          childAspectRatio: 1.0,
          children: boardWidgetList,
        ),
      ),
    );
  }

  void play(x, y) {
    // TODO BUG: audio only plays when user is playing, not when computer is
    // playing
    if (game.getCurrentPlayer() is! ComputerPlayer) {
      if (game.play(x, y)) AppAudio.getInstance().playEffect(AppAudio.effectPop);
    }
  }

  Widget getTileWidget(int x, int y) {
    int? tile = game.board.get(x, y);
    if (tile == null) return const SizedBox();
    if (tile == -1) return BlockerObject().getTile();
    Player play = game.players[tile];
    if (play.lastx == x && play.lasty == y) return play.getBigTile();
    for (int i = 0; i < 4 && game.winset != null; i++) {
      if (game.winset![i][0] == x && game.winset![i][1] == y) return play.getBigTile();
    }
    return play.getTile();
  }
  // @override
  // State<GameBoard> createState() => _GameBoardState();
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
          tile,
        ],
      ),
      onTapInside: (event) => onTap(),
    );
  }
}
