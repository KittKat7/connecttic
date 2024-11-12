import 'package:flutter/material.dart';

/// Abstract parent class for objects which are displaye on the game board.
/// [getTile] and [getBigTile] return the apprpriate tiles for the object being displayed.
abstract class GameObject {
  /// Returns the current tile as a widget.
  Widget getTile();

  /// Returns a larger version of the current tile, scaled to fit within a certain size.
  Widget getBigTile() {
    return Transform.scale(
      scale: 1.25,
      child: getTile(),
    );
  }
}

/// Represents a blocker object that can be used to block player movement or other game logic.
class BlockerObject extends GameObject {
  /// The tile displayed when the blocker is active, scaled down from its original size.
  static final Widget _tileBase = Image.asset(
    'assets/coins/cross_pixel.png',
    fit: BoxFit.cover,
    filterQuality: FilterQuality.none,
    width: double.infinity,
  );
  static Widget _tile = Transform.scale(scale: 0.75, child: _tileBase);

  /// Sets the color of the blocker's tile to a specific value.
  static setColor(Color c) {
    _tile = Transform.scale(
        scale: 0.75,
        child: ColorFiltered(
            colorFilter: ColorFilter.mode(c, BlendMode.modulate),
            child: _tileBase));
  }

  /// Returns the current tile as a widget.
  @override
  Widget getTile() {
    return _tile;
  }
}
