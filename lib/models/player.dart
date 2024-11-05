import 'package:connecttic/models/game_object.dart';
import 'package:flutter/material.dart';

class Player extends GameObject {
  final String _username;
  String get username {
    return _username;
  }

  @override
  Widget getTile() {
    return Transform.scale(scale: 0.75, child: _tile);
  }

  @override
  Widget getBigTile() {
    return _tile;
  }

  int lastx;
  int lasty;
  final Widget _tile;

  Player(String username, Widget tile, [Color color = Colors.grey])
      : _username = username,
        _tile = color == Colors.transparent
            ? tile
            : ColorFiltered(
                colorFilter: ColorFilter.mode(color, BlendMode.modulate),
                child: tile,
              ),
        lastx = -1,
        lasty = -1 {
    if (!Player._isValidUsername(username)) throw Exception("Invalid username");
  }

  static bool _isValidUsername(String username) {
    if (username.isEmpty) return false;
    if (["-"].contains(username)) return false;
    return true;
  }
}
