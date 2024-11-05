import 'package:flutter/material.dart';

abstract class GameObject {
  Widget getTile();
  Widget getBigTile() {
    return Transform.scale(
      scale: 1.25,
      child: getTile(),
    );
  }
}

class BlockerObject extends GameObject {
  static const Widget _tile = Icon(Icons.check_box_outline_blank_rounded);

  @override
  Widget getTile() {
    return _tile;
  }
}
