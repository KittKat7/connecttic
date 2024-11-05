import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

import '../models/board.dart';

/// This widget displays the game board.
class GameBoard extends StatelessWidget {
  final Board board;
  final void Function(int, int) tapCallBack;
  const GameBoard({super.key, required this.board, required this.tapCallBack});

  @override
  Widget build(BuildContext context) {
    List<Widget> boardWidgetList = [];
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

class _BoardTile extends StatelessWidget {
  final Widget tile;
  final void Function() onTap;
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
