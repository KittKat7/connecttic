import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../models/board.dart';

/// This widget displays the game board.
class GameBoard extends StatelessWidget {
  /// The board which should be displayed.
  final Board board;

  /// The function to run when tapped/clicked.
  final void Function(int, int) tapCallBack;

  /// Const constructor.
  const GameBoard({super.key, required this.board, required this.tapCallBack});

  @override
  Widget build(BuildContext context) {
    // List of all widgets on the board.
    List<Widget> boardWidgetList = [];
    // For every x and every y, add the tile to the list witht he correct widget and onTap function.
    for (int h = 0; h < board.height; h++) {
      for (int w = 0; w < board.width; w++) {
        boardWidgetList.add(
          _BoardTile(
            tile: board.getTile(w, h),
            onTap: () => tapCallBack(w, h),
          ),
        );
      }
    }
    // Return the widget.
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: board.width,
        childAspectRatio: 1.0,
        children: boardWidgetList,
      ),
    );
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
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme(context).primary),
        ),
        child: tile,
      ),
      onTapInside: (event) => onTap(),
    );
  }
}
