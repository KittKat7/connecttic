import 'package:flutter/material.dart';

/// A tile is what is used on the game board. Tile is abstract, there cannot be just a tile.
/// [id] is the player id for the tile, or an empty string if not a player tile.
/// [highlight] is whether the tile is highlighted, if it is it will be displayed bigger than if its
/// not.
/// [marker] is the widget used to mark this tile on the graphics display of the board.
abstract class Tile {
  String get id;
  bool highlight = false;
  Widget get marker;
}

/// EmptyTile is used to mark unused or unplayed spots on the board.
class EmptyTile extends Tile {
  @override
  String get id => "";
  @override
  Widget get marker => const SizedBox();
}

/// BlockerTile markes areas which cannot be used by the current player on the current turn due to
/// their play last turn.
class BlockerTile extends Tile {
  @override
  String get id => "";
  @override
  Widget get marker => const Icon(Icons.check_box_outline_blank_rounded);
}

/// PlayerTile is used to mark the player pieces on the board.
class PlayerTile extends Tile {
  final String _id;
  final Widget _marker;
  PlayerTile({required String id, required Widget marker, required Color color})
      : _id = id,
        // If the color is transparent then dont modify marker, otherwise change the marker to match
        // the color.
        _marker = color == Colors.transparent
            ? marker
            : ColorFiltered(
                colorFilter: ColorFilter.mode(color, BlendMode.modulate),
                child: marker,
              );
  @override
  String get id => _id;
  @override
  Widget get marker => highlight
      ? Transform.scale(scale: 1, child: _marker)
      : Transform.scale(scale: 0.75, child: _marker);

  /// Makes a clone of the PlayerTile with the same id and marker as this tile.
  PlayerTile get clone =>
      PlayerTile(id: _id, marker: _marker, color: Colors.transparent);
}
