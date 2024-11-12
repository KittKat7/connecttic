import 'package:flutter/material.dart';
import 'package:kittkatflutterlibrary/kittkatflutterlibrary.dart';

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
  static Widget _tile = Transform.scale(
      scale: 0.75,
      child: const ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.red, BlendMode.modulate),
          child: Image(
            image: AssetImage('assets/coins/cross_pixel.png'),
            fit: BoxFit.cover,
            filterQuality: FilterQuality.none,
          )));

  static setColor(Color c) {
    _tile = Transform.scale(
        scale: 0.75,
        child: ColorFiltered(
            colorFilter: ColorFilter.mode(c, BlendMode.modulate),
            child: const Image(
              image: AssetImage('assets/coins/cross_pixel.png'),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.none,
            )));
  }

  @override
  Widget getTile() {
    return _tile;
  }
}
